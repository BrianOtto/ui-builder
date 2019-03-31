var uiDB = class {
    constructor() {
        this.indexedDB = typeof window == 'object' ? window.indexedDB : self.indexedDB
    }
    
    displayError(e) {
        console.log('uiDB Error: ', e)
    }
    
    connect() {
        var db = this.indexedDB.open('ui-builder', 1)
        
        db.onupgradeneeded = function(e) {
            var db = e.target.result

            if (db.objectStoreNames.contains('script')) {
                db.deleteObjectStore('script')
            }

            db.createObjectStore('script')
        }
        
        db.onerror = this.displayError
        
        return db
    }
    
    getScript(name, cb, decode, toURL) {
        var db = this.connect()
        var me = this

        db.onsuccess = function(e) {
            var db = e.target.result
            
    		var transaction = db.transaction(['script'], 'readonly')
    		
    		transaction.oncomplete = function(e) {
    			db.close()
    		}
    		
    		transaction.onerror = this.displayError
    		
    		var objectStore = transaction.objectStore('script')
    		
    		var script = objectStore.get(name);
            
    		script.onsuccess = function(e) {
    		    var result = e.target.result
    		    
    		    if (decode) {
    		        result = me.decodeURI(result, toURL)
    		    }
    		    
    		    cb(result)
    		}
    		
    		script.onerror = this.displayError
        }

        db.onerror = this.displayError
    }
    
    addScript(name, data, cb) {
        var db = this.connect()

        db.onsuccess = function(e) {
            var db = e.target.result
            
    		var transaction = db.transaction(['script'], 'readwrite')
    		
    		transaction.oncomplete = function(e) {
    			cb(true)
    			db.close()
    		}
    		
    		transaction.onerror = function(e) {
    		    cb(false)
    		    this.displayError(e)
    		}
    		
    		var objectStore = transaction.objectStore('script')
    		
    		objectStore.put(data, name)
        }

        db.onerror = this.displayError
    }
    
    decodeURI(uri, toURL) {
        var uriSyntax = uri.split(':')
        var uriScheme = uriSyntax[0]
        
        if (uriScheme != 'data') {
            return ''
        }
        
        var uriPath = uriSyntax[1] || ''
        uriPath = uriPath.split(',')
        
        var uriMediaTypeAndExt = uriPath[0]
        uriMediaTypeAndExt = uriMediaTypeAndExt.split(';')
        
        var uriMediaType = uriMediaTypeAndExt[0]
        var uriExtension = uriMediaTypeAndExt[1] || ''
        
        var uriData = uriPath[1] || ''
        
        var decoded = (uriExtension == 'base64') ? atob(uriData) : uriData
        
        if (toURL) {
            var buffer = new ArrayBuffer(decoded.length)
            var dataView = new DataView(buffer)
            
            for (var i = 0; i < decoded.length; i++) {
                dataView.setUint8(i, decoded.charCodeAt(i))
            }
            
            var blob = new Blob([dataView], { type: uriMediaType })
            var data = URL.createObjectURL(blob)
        } else {
            var data = decoded
        }
        
        return data
    }
}