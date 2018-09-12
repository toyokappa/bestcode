import moment from 'moment'
import Converter from '../util/converter'
import Autolink from '../lib/autolink'

export default class Message {
  generateMessage(msgData, profilePath, userImg, msgSide) {
    switch(msgData.message_type) {
      case 'text':
        return this.generateTextMessage(msgData, profilePath, userImg, msgSide);
      case 'review_req':
        return this.generateReviewReqMessage(msgData, profilePath, userImg, msgSide);
      case 'image':
        return this.generateImageMessage(msgData, profilePath, userImg, msgSide);
      case 'file':
        return this.generateFileMessage(msgData, profilePath, userImg, msgSide);
    }
  }

  generateTextMessage(msgData, profilePath, userImg, msgSide) {
    const escapeMsg = Converter.escapeHtml(msgData.body);
    const indentionMsg = Converter.enterCode(escapeMsg);
    const linkableMsg = Autolink.link(indentionMsg);
    const msgCreatedAt = moment.unix(msgData.created_at.seconds).format('H:mm');
    const msgElm = `<div class='chat-item' data-class='${msgSide}'>
                      <a class='avatar w-40 blue' href='${profilePath}'>
                        <img src='${userImg}'>
                      </a>
                      <div class='chat-body chat-width'>
                        <div class='chat-content rounded msg'>${linkableMsg}</div>
                        <div class='chat-date date'>${msgCreatedAt}</div>
                      </div>
                    </div>`;
    return msgElm;
  }

  generateReviewReqMessage(msgData, profilePath, userImg, msgSide) {
    const userName = profilePath.replace('/users/profiles/', '')
    const regex = new RegExp(`https://github.com/${userName}/[\\w\\d]+/pull/\\d+`);
    const reviewReqUrl = msgData.body.match(regex)[0];
    const msgCreatedAt = moment.unix(msgData.created_at.seconds).format('H:mm');
    const msgElm = `<div class='chat-item' data-class='${msgSide}'>
                      <a class='avatar w-40 blue' href='${profilePath}'>
                        <img src='${userImg}'>
                      </a>
                      <div class='chat-body chat-width'>
                        <div class='chat-content rounded msg d-block review-request'>
                          【レビューリクエスト】<br>
                          下記PRのレビューをお願いします。<br>
                          <a href=${reviewReqUrl} class="d-block" target="_blank"><u>${reviewReqUrl}</u></a>
                        </div>
                        <div class='chat-date date'>${msgCreatedAt}</div>
                      </div>
                    </div>`;
    return msgElm.replace(/[\r\n]\s+/g, '');
  }

  generateImageMessage(msgData, profilePath, userImg, msgSide) {
  }

  generateFileMessage(msgData, profilePath, userImg, msgSide) {
  }
}
