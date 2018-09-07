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

export default Converter;
