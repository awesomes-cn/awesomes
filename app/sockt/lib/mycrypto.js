YAML = require('yamljs');

var crypto = require('crypto'),
    fs = require("fs")


if(!global.SETTING){
  YAML.load(/.+awesomes/.exec(__dirname)[0] + "/config/local_env.yml", function(result){
    global.SETTING = result;
  })
}

exports.mycrypto = {
  encrypt: function(text){
    var cipher = crypto.createCipheriv(global.SETTING.ENCODE_ALG,global.SETTING.ENCODE_KEY,global.SETTING.ENCODE_IV)
    var crypted = cipher.update(text,'utf-8',"base64")
    crypted += cipher.final("base64");
    return crypted;
  },

  decrypt: function(text){
    var decipher = crypto.createCipheriv(global.SETTING.ENCODE_ALG,global.SETTING.ENCODE_KEY,global.SETTING.ENCODE_IV)
    var dec = decipher.update(text,'base64','utf8')
    dec += decipher.final('utf8');
    return dec;
  }

}
