export default class Flash {
  constructor($root) {
    this.$root = $root;
    this.showFlash();
  }

  showFlash() {
    this.$root.unbind('click').click(this.hideFlash);
    this.$root.stop();
    const height = this.$root.outerHeight();
    this.$root.css("bottom", -height);
    this.$root.show();
    this.$root.animate({ bottom: 0 }, 600).delay(5000).animate({ bottom: -height }, 600).fadeOut(0);
  }

  hideFlash(e) {
    const $target = $(e.target);
    $target.stop();
    $target.fadeOut(500);
  }
}
