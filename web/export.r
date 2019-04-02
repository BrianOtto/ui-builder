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
    
    ; log errors only
    if find text "**" [ui-main-write text exit]
    
    ; or probe debugging
    if find text "^"" [if text <> "^"^"" [ui-main-write text]]
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
    
    let response = await fetch(url)
    let buffer = await response.arrayBuffer()
    
    return reb.Binary(buffer)
}

ui-main-write: js-awaiter [
    log [text!]
]{
    let log = reb.Spell(reb.ArgR('log'))
    console.log(log)
}

ui-main: adapt 'console []

; TODO: get API saving / loading working with Indexed DB

ui-video-play: js-native [] {
    let video = document.querySelector('[data-type="video"]')
    video.contentWindow.postMessage('{"event": "command", "func": "playVideo", "args": ""}', '*')
}

ui-video-stop: js-native [] {
    let video = document.querySelector('[data-type="video"]')
    video.contentWindow.postMessage('{"event": "command", "func": "stopVideo", "args": ""}', '*')
}