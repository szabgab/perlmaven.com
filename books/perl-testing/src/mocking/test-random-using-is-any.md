# Test using `is_any`

* [Test::IsAny](https://metacpan.org/pod/Test::IsAny) was created based on the earlier example.

We can easily test if the returned values fall are integer numbers and fall in the right range (we have even created the `is_any` function for this), but what if we would like to be more precise in our tests? What if we would like to control the randomness?

{% embed include file="src/examples/mock-random/t/test-is-any.t" %}

```
prove -lv t/test-is-any.t
```

