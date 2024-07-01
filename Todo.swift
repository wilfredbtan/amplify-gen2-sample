// swiftlint:disable all
import Amplify
import Foundation

public struct Todo: Model {
  public let id: String
  public var content: String?
  public var isDone: Bool
  public var _version: Int?
  public var _deleted: Bool?
  public var _lastChangedAt: Int?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      content: String? = nil,
      isDone: Bool,
      _version: Int? = nil,
      _deleted: Bool? = nil,
      _lastChangedAt: Int? = nil) {
    self.init(id: id,
      content: content,
      isDone: isDone,
      _version: _version,
      _deleted: _deleted,
      _lastChangedAt: _lastChangedAt,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      content: String? = nil,
      isDone: Bool,
      _version: Int? = nil,
      _deleted: Bool? = nil,
      _lastChangedAt: Int? = nil,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.content = content
      self.isDone = isDone
      self._version = _version
      self._deleted = _deleted
      self._lastChangedAt = _lastChangedAt
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}