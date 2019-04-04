; Ren-C Interface

lib/read: read: function [
    source [any-value!]
][
    ui-main-read to text! source
]

lib/write-stdout: write-stdout: function [
    text [text! char!]
][
    if char? text [text: my to-text]
    
    ; TODO: look into stripping the extra whitespace
    trim/with text ">>"
    
    ui-main-write text
]

lib/input: input: js-awaiter [
    return: [text!]
]{
    return new Promise(function(resolve, reject) {
        runCommand = function(text) {
            resolve(reb.Text(text))
        }
    })
}

; UI Builder

ui-main-read: js-awaiter [
    return: [binary!]
    url [text!]
]{
    let url = reb.Spell(reb.ArgR('url'))
    
    let response = await fetch(url, { cache: 'no-store' })
    let buffer = await response.arrayBuffer()
    
    return reb.Binary(buffer)
}

ui-main-write: js-awaiter [
    log [text!]
]{
    let log = reb.Spell(reb.ArgR('log'))
    
    if (debug === true) {
        console.log(log)
    }
}

ui-main: adapt 'console []
