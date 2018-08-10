export default class PreviewImage {
  constructor($root) {
    this.$root = $root;
    this.bind();
  }

  createPreview(e) {
    const file = e.target.files[0];
    const $preview = $(e.target).closest('.preview-field').find('.preview');
    const $image = $preview.find('img');
    const reader = new FileReader();
    console.log(e.target, $preview[0], $image[0])

    $image.remove();
    reader.readAsDataURL(file);
    reader.addEventListener('load', (re) => {
      const img = document.createElement('img');
      img.className = 'mw-100 mb-3';
      img.src = re.target.result;
      $preview.append(img);
    });
  }

  bind() {
    this.$root.on('change', '.select-image', this.createPreview);
  }
}
