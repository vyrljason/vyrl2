//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Decodable

final class DataToModelJSONDeserializer: DataToModelDeserializing {

    private let jsonSerializationClass: JSONSerializationProtocol.Type

    init(jsonSerializator: JSONSerializationProtocol.Type = JSONSerialization.self) {
        jsonSerializationClass =  jsonSerializator
    }

    public func deserialize<Model: Decodable>(data: Data, model: Model.Type) throws -> Model {
        let json = try jsonSerializationClass.JSONObjectWithData(data, options: JSONSerialization.ReadingOptions())
        let model = try model.decode(json)
        return model
    }
}
