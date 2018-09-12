import Autolinker from 'autolinker'
import _ from 'lodash'

export default class Autolink {
  static link(message) {
    const options = {
      className: 'autolink',
    };

    return Autolinker.link(message, options);
  }
}
