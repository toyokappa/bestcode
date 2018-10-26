let Converter = {};

const htmlMaps = {
  '<': '&lt;',
  '>': '&gt;',
  '"': '&quot;',
  '\'': '&#39;'
};

Converter.escapeHtml = str => {
  return (str + '').replace(/[<>'"]/g, key => {
    return htmlMaps[key];
  });
};

Converter.enterCode = str => {
  return (str + '').replace(/\r?\n/g, '<br>');
}

Converter.markdown = str => {
  const preMarkdown = (str + '').replace(/```<br>(.+)<br>```/g, '<pre>$1</pre>');
  return preMarkdown.replace(/`(.+)`/g, '<code>$1</code>');
}

export default Converter;
