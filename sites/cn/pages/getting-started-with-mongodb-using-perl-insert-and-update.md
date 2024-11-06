---
title: "perl与MongoDB入门 - 简单的添加和更新操作"
timestamp: 2016-05-31T06:50:01
tags:
  - MongoDB
published: true
original: getting-started-with-mongodb-using-perl-insert-and-update
books:
  - mongodb
author: szabgab
translator: fenggao
---


[MongoDB](http://www.mongodb.org/)是一个开源的NoSQL数据库。本文我们将介绍其入门知识：如何在MongoDB集合中添加文档，以及如何更新之。


## 添加元素

下面是最简单的一个例子：往集合里加两个元素。

{% include file="examples/mongodb_insert_two_elements.pl" %}

`my $client = MongoDB::MongoClient->new(host => 'localhost', port => 27017);`此处用来连接MongoDB服务，该服务以默认端口运行在本机。

下面这行代码创建了一个新的数据库。`my $db   = $client->get_database( 'example_' . $$ . '_' . time  );`

为了避免重名，数据库名由当前进程id`$$`和当前时间`time`组成。

一旦有了数据库实例`$db`，我们就可以获取一个集合，类似于关系型数据库（比如sqlserver,mysql）中的表。不过和表不同的是，我们没必要运行sql命令来创建，也不需要表的定义（schema）。`my $people_coll = $db->get_collection('people');`

在接下来的两行中，我们往集合里添加了两个元素，这两个元素都是哈希表。MongoDB的叫法是文档（documents）。

```perl
$people_coll->insert( {
    name => 'First',
});

$people_coll->insert( {
    name => 'Second',
});
```

然后调用`find`函数来获取所有文档。这个函数会返回一个所有文档的迭代器。用`next`函数就可以完成遍历。

```perl
my $people = $people_coll->find;
while (my $p = $people->next) {
    print Dumper $p;
}
```

每次迭代都返回一个哈希表`$p`, 用Data::Dumper可以打印其值。

```
$VAR1 = {
          '_id' => bless( {
                          'value' => '52861f9602490acc35000000'
                        }, 'MongoDB::OID' ),
          'name' => 'First'
        };
$VAR1 = {
          '_id' => bless( {
                          'value' => '52861f9602490acc35000001'
                        }, 'MongoDB::OID' ),
          'name' => 'Second'
        };
```

除了加入的名字外，每个文档还包括了一个特有的`_id`，也叫 [ObjectIDd](http://docs.mongodb.org/manual/reference/object-id/).(详情参见[规范](http://docs.mongodb.org/manual/reference/object-id/))

最后一行`$db->drop;`直接把当前数据库删除了. 

## 手动删除数据库
如果因为某种原因，比如脚本抛了异常，导致数据库没被删除，这时我们也可以手动删除它，这个需要借助于`mongo`命令行。

```
$ mongo
MongoDB shell version: 2.4.6
connecting to: test
> show dbs
demo   0.078125GB
dev_site  0.203125GB
example_13930_1384522288   0.203125GB
local   0.078125GB

> use example_13930_1384522288
switched to db example_13930_1384522288

> db.dropDatabase()
{ "dropped" : "example_13930_1384522288", "ok" : 1 }

> show dbs
demo   0.078125GB
dev_site   0.203125GB
local  0.078125GB

> exit
bye
$
```


`show dbs`列出所有数据库。

`use example_13930_1384522288` 切换到要删除的数据库。

`db.dropDatabase()` 删除数据库。

`exit`, 退出命令行.

## 在END块删除数据库

当然我们也可以在`END` 块删除数据库:

```perl
END {
    $db->drop if $db;
}
```
即便有异常抛出，这块代码最后也会保证被调用。

`if`保证了我们不会调用空的数据库实例。

## 更新某个文档

下面我们来展示如何更新文档。在第二个`insert`后我加入了如下代码：

```perl
$people_coll->update(
    { name => 'Second'},
    { '$set' => {
            phone => '1-123',
        },
    },
);
```

`update` 接受两个哈希表参数。第一个`{ name => 'Second'}`选中要更新的文档(类似于sql的where语句)。也就是说，挑出name等于“Second”的那个文档。

第二个参数指定了如何更新文档。 `'$set'` 是一条MongoDB命令，告诉数据库引擎重新设置键值对。`{ phone => '1-123'}` 就是新设置的键值对，不管键之前是否存在，该操作都会执行。

输出如下：
```
$VAR1 = {
          'name' => 'First',
          '_id' => bless( {
                          'value' => '52862563527197d436000000'
                        }, 'MongoDB::OID' )
        };
$VAR1 = {
          'name' => 'Second',
          '_id' => bless( {
                          'value' => '52862563527197d436000001'
                        }, 'MongoDB::OID' ),
          'phone' => '1-123'
        };
```

ObjectIds 变了，因为程序重新跑了一次。这个不是重点，关键是第二个文档现在有'name','phone'两个属性了，而第一个文档还是只有一个属性'name'。






