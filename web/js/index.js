var runCommand
var debug = false

var allElementIds = []
var currentToggle = { id: '', border: '' }

newId = function(type) {
    let max = allElementIds.length
    
    for (var i = 0; i <= max; i++) {
        var id = type + parseInt(i + 1)
        
        if (allElementIds.indexOf(id) == -1) {
            break
        }
    }
    
    return id
}

getId = function(id) {
    var exists = false
    
    for (i in allElementIds) {
        if (allElementIds[i] == id) {
            exists = true
            break
        }
    }
    
    return exists
}

addElement = function(add, more) {
    var current = document.querySelector('#currentId')
    var element = document.querySelector('#' + current.innerHTML)
    
    var elementType = element.getAttribute('data-type')
    var addType = add.getAttribute('data-type')
    
    if (elementType == 'button') {
        if (addType != 'text' && addType != 'icon') {
            showError('You can not add a ' + addType + ' to a button')
            return
        }
    }
    
    if (addType == 'icon') {
        if (elementType != 'button' && elementType != 'col') {
            showError('You can not add an icon to a ' + elementType)
            return
        }
    }
    
    if (elementType == 'row' && addType != 'col') {
        showError('You must add a column first')
        return
    }
    
    if (elementType == 'button' && addType == 'text') {
        var span = document.querySelector('#' + element.id + ' > span')
        if (span) { span.remove() }
    }
    
    if (elementType == 'button' && addType == 'icon') {
        var icon = document.querySelector('#' + element.id + ' > i')
        if (icon) { icon.remove() }
        
        add.className += ' uk-margin-small-left'
    }
    
    if (getId(add.id)) {
        showError('You have already used this id')
        return
    } else {
        allElementIds.push(add.id)
    }
    
    add.setAttribute('uk-tooltip', '#' + add.id)
    
    if (elementType == 'button' && addType == 'text') {
        element.insertBefore(add, element.firstChild)
    } else {
        element.appendChild(add)
    }
    
    // resolves a bug in UIkit where margin-left is set
    // to -40px when there is nothing inside the grid
    if (add.hasAttribute('uk-grid')) {
        add.style.marginLeft = '0px'
    }
    
    // continue adding to the current parent
    if (more == 1 || addType == 'text' || addType == 'icon') {
        if (add.nodeName == 'DIV') {
            add.style.border = '1px dashed #FF0000'
        }
    } else {
        toggleCurrent(true)
        
        updateCurrent(add)
        
        if (add.nodeName == 'DIV') {
            toggleCurrent()
        }
    }
}

toggleCurrent = function(hideOnly) {
    var current = document.querySelector('#currentId')
    var element = document.querySelector('#' + current.innerHTML)
    
    if (currentToggle.id == element.id) {
        if (element.nodeName != 'DIV') {
            if (currentToggle.border != '') {
                element.style.border = currentToggle.border
            } else {
                element.style.border = ''
            }
        }
        
        document.querySelector('#currentShowHide').innerHTML = 'Show'
        currentToggle = { id: '', border: '' }
    } else if (hideOnly !== true) {
        if (element.id != 'canvas') {
            var border = (element.style.border) ? element.style.border : ''
            currentToggle = { id: element.id, border: border }
            document.querySelector('#currentShowHide').innerHTML = 'Hide'
            
            element.style.border = '1px dashed #FF0000'
        }
    }
}

updateCurrent = function(element) {
    document.querySelector('#currentId').innerHTML = element.id
    document.querySelector('#currentParent').innerHTML = element.parentNode.id
    document.querySelector('#currentType').innerHTML = element.getAttribute('data-type')
    
    if (element.nodeName == 'DIV') {
        document.querySelector('#currentShowHide').disabled = true
    } else {
        document.querySelector('#currentShowHide').disabled = false
    }
}

removeCurrent = function(hideOnly) {
    var current = document.querySelector('#currentId')
    var element = document.querySelector('#' + current.innerHTML)
    
    if (element.id == 'canvas') {
        showError('You can not remove the canvas')
    } else {
        var parentNode = element.parentNode
        
        element.remove()
        
        updateCurrent(parentNode)
    }
}

updateCode = function() {
    let code = document.querySelector('#code').value
    if (code != '') { runCommand(code) }
    
    document.querySelector('#input').focus()
}

showAlert = function(message) {
    UIkit.notification({
        message : '<i class="fas fa-info-circle uk-margin-small-right"></i>' + message,
        status  : 'primary',
        timeout : 5000,
        pos     : 'top-center'
    })
}

showError = function(message) {
    UIkit.notification({
        message : '<i class="fas fa-exclamation-triangle uk-margin-small-right"></i>' + message,
        status  : 'danger',
        timeout : 5000,
        pos     : 'top-center'
    })
}

document.addEventListener('click', function(e) {
    if (e.target) {
        switch (e.target.id) {
            case 'currentShowHide' :
                toggleCurrent()
                break
            case 'currentRemove' :
                removeCurrent()
                break
            case 'codeButtonSave' :
                updateCode()
                break
        }
    }
})

document.querySelector('#input').onkeydown = function(e) {
    if (e.keyCode == 13) {
        var command = 'ui-parse {' + this.value + '}'
        
        // see lib/input @ export.r
        runCommand(command)
        
        this.value = ''
        
        e.preventDefault()
    }
}

document.querySelector('#upload').onchange = function(e) {
    let file = e.target.files[0]
    if (!file) { return }
    
    var reader = new FileReader()
    reader.onload = function(e) {
        var contents = e.target.result
        
        var html = document.createElement('html')
        html.innerHTML = contents
        
        let body = html.querySelector('body').innerHTML
        document.querySelector('#canvas').innerHTML = body
        
        let codeFind = /let uiCode = 'data:application\/rebol;base64,(.*)'/g
        let codeMatches = codeFind.exec(contents)
        
        if (typeof codeMatches[1] !== 'undefined') {
            try {
                document.querySelector('#code').value = atob(codeMatches[1])
                updateCode()
            } catch(e) {
                showError('There was an error importing the Rebol code')
            }
        }
        
        // document.querySelector('#loader').remove()
    }
    
    /* Note: The upload is so quick that this loading screen is not needed,
             but we may have to revisit this when we start parsing larger documents
    
    var loader = document.createElement('div')
    loader.insertAdjacentHTML('beforeend', '<h3><i class="fas fa-circle-notch fa-spin uk-margin-small-right"></i>Uploading your design ...</h3>')
    loader.id = 'loader'
    
    let canvas = document.querySelector('#canvas')
    canvas.insertBefore(loader, canvas.firstChild)
    
    */
    
    reader.readAsText(file)
}

window.addEventListener('load', function() {
    document.querySelector('#input').focus()
    
    if (typeof caches !== 'undefined') {
        caches.keys().then(function(names) {
            for (let name of names) {
                caches.delete(name)
            }
        })
    }
    
    let hasWasm = typeof WebAssembly === 'object'
    let hasShared = typeof SharedArrayBuffer !== 'undefined'
    var hasThreads = false
    
    if (hasWasm && hasShared) {
        let test = new WebAssembly.Memory({
            'initial': 0, 'maximum': 0, 'shared': true
        })
        
        hasThreads = (test.buffer instanceof SharedArrayBuffer)
    }
    
    var libr3 = document.createElement('script')
    
    if (hasWasm && hasThreads) {
        console.log('UI Builder - Using Emscripten')
        libr3.src = 'js/libr3-emscripten.js'
    } else {
        console.log('UI Builder - Using Emterpreter')
        libr3.src = 'js/libr3-emterpreter.js'
        
        var msg = '<i class="fas fa-exclamation-triangle fa-2x"></i><h3>Performance Warning</h3><br><br>Your browser does not have WebAssembly Threads or SharedArrayBuffer enabled. This application runs much faster when those are turned on. Please consider enabling this by following these <a href="https://github.com/hostilefork/replpad-js/wiki/Enable-WASM-Threads" target="_blank">instructions</a>.'
        UIkit.modal.alert('<div class="uk-alert-danger" uk-alert>' + msg + '</div>').then(function() {
            document.querySelector('#input').focus()
        })
    }
    
    document.body.appendChild(libr3)
    
    workersAreLoaded = function() {
        if (typeof runDependencyWatcher === 'undefined' || runDependencyWatcher !== null) {
            setTimeout(workersAreLoaded, 100)
        } else {
            Promise.resolve(null)
            .then(function() {
                // init Ren-C
                reb.Startup()
                
                // load the extensions
                reb.Elide(
                    'for-each collation builtin-extensions',
                    '[load-extension collation]'
                )
                
                // grab the UI Builder functions
                return fetch('index.r', { cache: 'no-store' })
                .then(function(response) {
                    return response.text()
                })
                .then(function(text) {
                    // load the UI Builder functions
                    reb.Elide(text)
                    
                    // grab the Ren-C functions
                    return fetch('export.r', { cache: 'no-store' })
                    .then(function(response) {
                        return response.text()
                    })
                    .then(function(text) {
                        // load the Ren-C functions
                        reb.Elide(text)
                        
                        // init the console
                        return reb.Promise('ui-main')
                    })
                })
            })
        }
    }
    
    setTimeout(workersAreLoaded, 0)
})
