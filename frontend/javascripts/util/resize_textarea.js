export default class ResizeTextarea {
  constructor($textarea) {
    this.$textarea = $textarea;
    this.defaultHeight = $textarea.height();
    this.bind();
  }

  resizeTextarea(e) {
    const target = e.target;
    const $target = $(target)
    const maxHeight = 209 // 改行10回分
    const paddingTop = Number($target.css('padding-top').split('px')[0]);
    const paddingBottom = Number($target.css('padding-bottom').split('px')[0]);
    const paddingY = paddingTop + paddingBottom;

    if(target.scrollHeight > target.offsetHeight) {
      if($target.height() >= maxHeight) return;

      $target.height(target.scrollHeight - paddingY);
    } else {
      const lineHeight = Number($target.css('lineHeight').split('px')[0]);
      while(true) {
        $target.height($target.height() - lineHeight);
        if(target.scrollHeight > target.offsetHeight) {
          $target.height(target.scrollHeight - paddingY);
          break;
        }
      }
    }
  }

  bind() {
    this.$textarea.on('input', this.resizeTextarea);
  }

  restoreSize() {
    this.$textarea.height(this.defaultHeight);
  }
}
