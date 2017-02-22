//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Decodable

protocol JSONToModelDeserializing: class {
    func deserialize<Model: Decodable>(json: Any, model: Model.Type) throws -> Model
}

final class JSONToModelDeserializer: JSONToModelDeserializing {
    func deserialize<Model: Decodable>(json: Any, model: Model.Type) throws -> Model {
        let model = try model.decode(json)
        return model
    }
}
