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

export default Converter;
