ui-alert: js-native [
    message [text!]
]{
    let message = reb.Spell(reb.ArgR('message'))
    showError(alert)
}

ui-error: js-native [
    message [text!]
]{
    let message = reb.Spell(reb.ArgR('message'))
    showError(message)
}

ui-parse: function [
    dsl [text!]
][
    trim/lines dsl
    matched: false
    
    parse dsl rules: [ any [
        "add " copy element to [" " | end] copy params to end
            (matched: true)
            
            (trim params)
            
            (id: mold "" parts: split params " ")
            
            (if not void? attempt [
                if find ["text" "icon" "image" "video"] element [
                    either (length? parts) == 0 [
                        ui-error "You are missing a required parameter"
                        return
                    ][
                        either any [
                            (first parts/1) == #"^"" 
                            (length? parts) == 1
                        ][
                            id: mold ""
                            
                            string: form parts
                            trim/with string "^""
                            
                            params: mold string
                        ][
                            id: mold parts/1
                            
                            remove parts
                            string: form parts
                            trim/with string "^""
                            
                            params: mold string
                        ]
                    ]
                ]
                
                do rejoin ["ui-" element "/add " id " " params]
             ][
                ui-error "You have entered an invalid command"
             ])
        
        |
        
        "get " copy id to end
            (matched: true)
            (trim id)
            (ui-get id)
        
        |
        
        "set " copy property thru " " copy value to end
            (matched: true)
            (trim property trim value trim/with value "^"")
            (ui-set property value)
        
        |
        
        "move to " copy id to end
            (matched: true)
            (trim id)
            (ui-move id)
        
        |
        
        ["remove" | "delete"]
            (matched: true)
            (ui-remove)
        
        |
        
        "undo"
            (matched: true)
            (ui-remove/undo)
        
        |
        
        "hide " copy type to end
            (matched: true)
            (trim type)
            (switch type [
                "layout" [ui-layout 0]
                "ids" [ui-ids 0]
             ] else [
                ui-error "You have entered an invalid command"
             ])
        
        |
        
        "show " copy type to end
            (matched: true)
            (trim type)
            (switch type [
                "layout" [ui-layout 1]
                "ids" [ui-ids 1]
             ] else [
                ui-error "You have entered an invalid command"
             ])
        
        |
        
        "export"
            (matched: true)
            (ui-export)
        
        |
        
        "debug"
            (matched: true)
            (ui-debug)
        
        |
        
        skip
    ] ]
    
    if not matched [ui-error "You have entered an unknown command"]
]

ui-row: js-native [
    id [text!]
    /add
    /more
]{
    var id = reb.Spell(reb.ArgR('id'))
    let add = reb.Did(reb.ArgR('add'))
    let more = reb.Did(reb.ArgR('more'))
    
    if (id == '') {
        id = newId('row')
    }
    
    var row = document.createElement('div')
    row.setAttribute('data-type', 'row')
    row.setAttribute('uk-grid', '')
    row.className = 'uk-width-1-1 uk-margin-remove-top'
    row.style.padding = '10px'
    row.id = id
    
    if (add == 1) {
        addElement(row, more)
    }
}

ui-col: ui.column: js-native [
    id [text!]
    /add
    /more
]{
    var id = reb.Spell(reb.ArgR('id'))
    let add = reb.Did(reb.ArgR('add'))
    let more = reb.Did(reb.ArgR('more'))
    
    if (id == '') {
        id = newId('col')
    }
    
    var col = document.createElement('div')
    col.setAttribute('data-type', 'col')
    col.className = 'uk-width-expand'
    col.style.padding = '10px'
    col.id = id
    
    if (add == 1) {
        addElement(col, more)
    }
}

ui-button: js-native [
    id [text!]
    /add
    /more
]{
    var id = reb.Spell(reb.ArgR('id'))
    let add = reb.Did(reb.ArgR('add'))
    let more = reb.Did(reb.ArgR('more'))
    
    if (id == '') {
        id = newId('button')
    }
    
    var button = document.createElement('button')
    button.setAttribute('data-type', 'button')
    button.className = 'uk-button uk-button-secondary'
    button.innerHTML = '<span>' + id + '</span>'
    button.id = id
    
    if (add == 1) {
        addElement(button, more)
    }
}

ui-text: js-native [
    id [text!]
    string [text!]
    /add
    /more
]{
    var id = reb.Spell(reb.ArgR('id'))
    let string = reb.Spell(reb.ArgR('string'))
    let add = reb.Did(reb.ArgR('add'))
    let more = reb.Did(reb.ArgR('more'))
    
    if (id == '') {
        id = newId('text')
    }
    
    var text = document.createElement('span')
    text.setAttribute('data-type', 'text')
    text.innerHTML = string
    text.id = id
    
    if (add == 1) {
        addElement(text, more)
    }
}

ui-icon: js-native [
    id [text!]
    name [text!]
    /add
    /more
]{
    var id = reb.Spell(reb.ArgR('id'))
    let name = reb.Spell(reb.ArgR('name'))
    let add = reb.Did(reb.ArgR('add'))
    let more = reb.Did(reb.ArgR('more'))
    
    if (id == '') {
        id = newId('icon')
    }
    
    var icon = document.createElement('i')
    icon.setAttribute('data-type', 'icon')
    icon.className = 'fas fa-' + name
    icon.id = id
    
    if (add == 1) {
        addElement(icon, more)
    }
}

ui-image: js-native [
    id [text!]
    url [text!]
    /add
    /more
]{
    var id = reb.Spell(reb.ArgR('id'))
    let url = reb.Spell(reb.ArgR('url'))
    let add = reb.Did(reb.ArgR('add'))
    let more = reb.Did(reb.ArgR('more'))
    
    if (id == '') {
        id = newId('image')
    }
    
    // TODO: detect https:// and update the url to match
    
    var image = document.createElement('img')
    image.setAttribute('data-type', 'image')
    image.className = 'uk-align-center'
    image.src = url
    image.id = id
    
    if (add == 1) {
        addElement(image, more)
    }
}

ui-video: js-native [
    id [text!]
    url [text!]
    /add
    /more
]{
    var id = reb.Spell(reb.ArgR('id'))
    let url = reb.Spell(reb.ArgR('url'))
    let add = reb.Did(reb.ArgR('add'))
    let more = reb.Did(reb.ArgR('more'))
    
    if (id == '') {
        id = newId('video')
    }
    
    // http://www.youtube.com/embed/dQw4w9WgXcQ (doesn't work on file://)
    // http://www.youtube.com/embed/cSp1dM2Vj48
    
    // ui-video-play: js-native [] {
    //     let video = document.querySelector('[data-type="video"]')
    //     video.contentWindow.postMessage('{"event": "command", "func": "playVideo", "args": ""}', '*')
    // }
    // 
    // ui-video-stop: js-native [] {
    //     let video = document.querySelector('[data-type="video"]')
    //     video.contentWindow.postMessage('{"event": "command", "func": "stopVideo", "args": ""}', '*')
    // }
    
    // TODO: detect https:// and update the url to match
    
    var video = document.createElement('iframe')
    video.setAttribute('data-type', 'video')
    video.setAttribute('allowfullscreen', '')
    video.className = 'uk-align-center'
    video.allow = 'accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture'
    video.frameborder = 0
    video.width = 560
    video.height = 315
    video.src = url + '?controls=0&autoplay=1&enablejsapi=1&mute=1'
    video.id = id
    
    if (add == 1) {
        addElement(video, more)
    }
}

ui-input: js-native [
    id [text!]
    /add
    /more
]{
    var id = reb.Spell(reb.ArgR('id'))
    let add = reb.Did(reb.ArgR('add'))
    let more = reb.Did(reb.ArgR('more'))
    
    if (id == '') {
        id = newId('input')
    }
    
    var input = document.createElement('input')
    input.setAttribute('data-type', 'input')
    input.className = 'uk-input'
    input.id = id
    
    if (add == 1) {
        addElement(input, more)
    }
}

ui-textarea: js-native [
    id [text!]
    /add
    /more
]{
    var id = reb.Spell(reb.ArgR('id'))
    let add = reb.Did(reb.ArgR('add'))
    let more = reb.Did(reb.ArgR('more'))
    
    if (id == '') {
        id = newId('textarea')
    }
    
    var textarea = document.createElement('textarea')
    textarea.setAttribute('data-type', 'textarea')
    textarea.className = 'uk-textarea'
    textarea.id = id
    
    if (add == 1) {
        addElement(textarea, more)
    }
}

ui-checkbox: js-native [
    id [text!]
    /add
    /more
]{
    var id = reb.Spell(reb.ArgR('id'))
    let add = reb.Did(reb.ArgR('add'))
    let more = reb.Did(reb.ArgR('more'))
    
    if (id == '') {
        id = newId('checkbox')
    }
    
    var checkbox = document.createElement('checkbox')
    checkbox.setAttribute('data-type', 'checkbox')
    checkbox.className = 'uk-checkbox'
    checkbox.id = id
    
    if (add == 1) {
        addElement(checkbox, more)
    }
}

ui-radio: js-native [
    id [text!]
    /add
    /more
]{
    var id = reb.Spell(reb.ArgR('id'))
    let add = reb.Did(reb.ArgR('add'))
    let more = reb.Did(reb.ArgR('more'))
    
    if (id == '') {
        id = newId('radio')
    }
    
    var radio = document.createElement('radio')
    radio.setAttribute('data-type', 'radio')
    radio.className = 'uk-radio'
    radio.id = id
    
    if (add == 1) {
        addElement(radio, more)
    }
}

ui-set: js-native [
    property [text!]
    value [text!]
]{
    var property = reb.Spell(reb.ArgR('property'))
    var value = reb.Spell(reb.ArgR('value'))
    
    // TODO: add error checking and the ability to set more events
    var current = document.querySelector('#currentId')
    var element = document.querySelector('#' + current.innerHTML)
    
    if (property == 'onclick') {
        element.setAttribute('onclick', 'runCommand(\'' + value + '\')')
    } else {
        if (CSS.supports(property, value)) {
            element.style[property] = value
        } else {
            element.setAttribute(property, value)
            
            if (property == 'id') {
                document.querySelector('#currentId').innerHTML = value
            }
        }
    }
}

ui-get: js-native [
    id [text!]
]{
    var id = reb.Spell(reb.ArgR('id'))
    
    if (id == 'parent') {
        var current = document.querySelector('#currentId')
        var element = document.querySelector('#' + current.innerHTML).parentNode
    } else {
        var element = document.querySelector('#' + id)
    }
    
    // TODO: make sure the element is under root
    if (element && element.id != 'root') {
        toggleCurrent(true)
        updateCurrent(element)
        toggleCurrent()
    } else {
        showError('You have entered an invalid element (' + id + ')')
    }
}

ui-move: js-native [
    id [text!]
]{
    var id = reb.Spell(reb.ArgR('id'))
    
    var to = document.querySelector('#' + id)
    
    if (to) {
        // TODO: make sure the element is under root and the move is valid
        //       i.e. don't put a row inside another row
        var current = document.querySelector('#currentId')
        var element = document.querySelector('#' + current.innerHTML)
        
        var elementClone = element.cloneNode(true)
        
        element.remove()
        to.appendChild(elementClone)
        
        updateCurrent(elementClone)
    } else {
        showError('You have entered an invalid element (' + id + ')')
    }
}

ui-remove: js-native [
    /undo
] {
    let undo = reb.Did(reb.ArgR('undo'))
    
    if (undo == 1) {
        if (currentRemove.parentNode) {
            currentRemove.parentNode.appendChild(currentRemove.element)
            updateCurrent(currentRemove.parentNode.lastChild)
        }
        
        currentRemove.parentNode = null
        currentRemove.element = null
    } else {
        removeCurrent()
    }
}

ui-layout: js-native [
    show [integer!]
]{
    let show = reb.UnboxInteger(reb.ArgR('show'))
    
    // TODO: preserve existing borders
    document.querySelectorAll('#canvas div').forEach((element) => {
        if (show == 1) {
            element.style.border = '1px dashed #FF0000'
        } else {
            element.style.border = ''
        }
    })
}

ui-ids: js-native [
    show [integer!]
]{
    let show = reb.UnboxInteger(reb.ArgR('show'))
    
    document.querySelectorAll('[uk-tooltip]').forEach((element) => {
        if (show == 1) {
            // HACK: this bypasses the logic that hides all active tooltips first
            //       and it is why we have to do another show() when hiding
            UIkit.tooltip(element)._show()
        } else {
            UIkit.tooltip(element).show()
            UIkit.tooltip(element).hide()
        }
    })
}

ui-export: function [][
    ui-layout 0
    
    content: read %export.html
    
    ; CSS
    
    css-uikit: read %css/uikit.min.css
    css-index: read %css/index.css
    
    replace content "/*CSS-UIKIT*/" css-uikit
    replace content "/*CSS-INDEX*/" css-index
    
    ; JavaScript
    
    js-uikit: read %js/uikit.min.js
    js-fa-brands: read %js/brands.min.js
    js-fa-solid: read %js/solid.min.js
    js-fa: read %js/fontawesome.min.js
    js-ui-db: read %js/ui-db.js
    
    replace content "/*JS-UIKIT*/" js-uikit
    replace content "/*JS-FA-BRANDS*/" js-fa-brands
    replace content "/*JS-FA-SOLID*/" js-fa-solid
    replace content "/*JS-FA*/" js-fa
    replace content "/*UI-DB*/" js-ui-db
    
    ; lib.js and worker.js for Emscripten
    
    replace content "%LIB%" read %js/libr3-emscripten.js.base64
    replace content "%WORKER%" read %js/libr3-emscripten.worker.js.base64
    
    ; lib.js for Emterpreter
    
    ; TODO: make Emterpreter optional to reduce file size
    replace content "%LIBEMT%" read %js/libr3-emterpreter.js.base64
    
    ; export.r
    
    replace content "%EXPORT%" enbase read %export.r
    
    ui-export-download to text! content
]

ui-export-download: js-native [
    content [text!]
]{
    let content = reb.Spell(reb.ArgR('content'))
    
    toggleCurrent(true)
    
    // get the HTML and remove all ids / tooltips
    var html = document.querySelector('#canvas').innerHTML
    html = html.replace(/uk-tooltip=\"#(.*?)\"/g, '')
    
    content = content.replace('<!--APP-->', html)
    
    // Note: this had to be done in JavaScript because Ren-C is not seeing global variables
    let code = document.querySelector('#code').value
    content = content.replace('%CODE%', btoa(code))
    
    var buffer = new ArrayBuffer(content.length)
    var dataView = new DataView(buffer)
    
    for (var i = 0; i < content.length; i++) {
        dataView.setUint8(i, content.charCodeAt(i))
    }
    
    var blob = new Blob([dataView], { type: 'text/html' })
    var blobURL = URL.createObjectURL(blob)
    
    var link = document.createElement('a')
    link.setAttribute('href', blobURL)
    link.setAttribute('download', 'app.html')
    link.style.display = 'none'
    
    document.body.appendChild(link)
    
    link.click()
    
    document.body.removeChild(link)
}

ui-debug: js-native [] {
    if (debug === false) {
        console.log('UI Builder - Debugging On')
        
        // prevents the console from outputting NULL
        setTimeout(function () { debug = true }, 500)
    } else {
        console.log('UI Builder - Debugging Off')
        debug = false
    }
}

; TODO: get export [html] working
; TODO: allow command history navigation with arrows
; TODO: get the UI to display properly on mobile
; TODO: add image uploader and JS startup code and api checkboxes
