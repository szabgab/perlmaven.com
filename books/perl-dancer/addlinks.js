function linkIncludeFiles() {
  document.querySelectorAll("div[data-embedify][data-app='include']").forEach((node) => {
    const file = node.getAttribute("data-option-file");
    if (!file) return;

    prefixes.forEach((prefix) => {
      if (file.startsWith(prefix)) {
        extensions.forEach((ext) => {
          if (file.endsWith(ext)) {
            createLink(node, file);
            return;
          }
        });
      }
    });
  });
}

function createLink(node, file) {
    // Create a link to the corresponding GitHub file
    const a = document.createElement("a");
    a.href = `${base_url}${file}`;
    a.textContent = file;
    a.target = "_blank";

    node.insertAdjacentElement("afterend", a);
}

document.addEventListener("DOMContentLoaded", linkIncludeFiles);
