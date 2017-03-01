import Kitura

// Create a new router
let router = Router()
let db = DataService(with: "db1")!

// Handle HTTP GET requests to /
router.get("/") { request, response, next in
    defer {
        next()
    }

    let result = db.get(valueOf: request.queryParameters["name"] ?? "default")

    switch(result) {
        case .success(let value):
            response.send("I remember your name is: \(value)")
            break
        case .failure(let error):
            response.send("I don't know you. Tell me your name?: \(error)")
    }
}

router.get("/write") { request, response, next in
    defer {
        next()
    }

    guard let key = request.queryParameters["key"],
        let newValue = request.queryParameters["value"] else {
        response.send("You need to provide 'key' and 'value' params.")
        return
    }

    let result = db.set(newValue, key)

    switch(result) {
        case .success:
            response.send("Written!")
        case .failure(let error):
            response.send("Error: \(error)")
    }
}

// Add an HTTP server and connect it to the router
Kitura.addHTTPServer(onPort: 3000, with: router)

// Start the Kitura runloop (this call never returns)
Kitura.run()
