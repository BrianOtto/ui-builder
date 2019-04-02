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
                if find ["text" "icon" "video"] element [
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
    
    ; libr3.js
    
    lib: read %js/libr3-emscripten.js
    lib: rejoin [js-ui-db "^/^/" lib]
    
    script-find: "pthreadMainJs = locateFile(pthreadMainJs);"
    script-replace: "new uiDB().getScript('worker.js', function(pthreadMainJs) { "
    replace lib script-find script-replace
    
    script-find: "getNewWorker: function() {"
    script-replace: "true, true) }, "
    replace lib script-find rejoin [script-replace script-find]
    
    replace content "%LIB%" enbase lib
    
    ; libr3.worker.js
    
    worker: read %js/libr3-emscripten.worker.js
    worker: rejoin [js-ui-db "^/^/" worker]
    
    replace/all worker "importScripts" "// importScripts"
    
    script-find: "if (typeof FS !== 'undefined'"
    script-replace: "new uiDB().getScript('lib.js', function(result) { importScripts(result); "
    replace worker script-find rejoin [script-replace script-find]
    
    script-find: "} else if (e.data.cmd === 'objectTransfer') {"
    script-replace: "}, true, true) "
    replace worker script-find rejoin [script-replace script-find]
    
    replace content "%WORKER%" enbase worker
    
    ; export.r
    
    export: read %export.r
    
    replace content "%EXPORT%" enbase export
    
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

; TODO: get export [html] working
; TODO: get importing an exported app working
; TODO: allow command history navigation with arrows
