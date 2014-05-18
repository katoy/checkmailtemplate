# -*- coding: utf-8 -*-

MESSAGE = {
  EXIST_1:         'E9001: %s: 既にファイルが存在しています。',
  NO_EXIST_1:      'E9002: %s:  存在しません。',
  NO_ACCESS_1:     'E9003: %s: アクセスできません。',
  BAD_TYPE_1:      'E9004: %%s: ファイル内容が %s です。',
  BAD_ENCODING_1:  'E9005: %%s: ファイルの ecndoing が utf8 でありません。%s と判定しました。',

  BAD_TYPE_2:      'E9010: %%s:%d %s TYPE: が指定されていません。',
  BAD_SUBJ_2:      'E9011: %%s:%d %s SUBJ: が指定されていません。',
  BAD_FROM_2:      'E9012: %%s:%d %s FROM: が指定されていません。',
  BAD_TO:          '',
  BAD_CC:          '',
  BAD_BCC:         '',
  BAD_BODY_2:      'E9013: %%s:%d %s BODY: が指定されていません。',
  BAD_SYNTAX_3:    'E9014: %s:%d %s が不正です。',
  ERROR_3:         'E9015: %s: %s %s',
}

def get_message(id)
  MESSAGE[id]
end
