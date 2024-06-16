
import Foundation

extension Gem {
  static let mock: [Gem] = (0...5).map { _ in
    let gem = Gem()
    gem.name = "Mock Gem"
    gem.timestamp = Date()
    gem.info = "Mock info"
    return gem
  }
}
