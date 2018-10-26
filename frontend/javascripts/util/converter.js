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
  return (str + '').replace(/```<br>(.+)<br>```/g, '<pre>$1</pre>');
}

export default Converter;
