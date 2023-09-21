

import SwiftUI

extension PreviewProvider {
  static var roseGem: Gem {
    let gem = Gem(context: PersistenceController.preview.container.viewContext)
    gem.name = "Rose Quartz"
    gem.info = "A pinkish quartz, found in many shapes and sizes. Rose Quartz was once the leader of the Crystal Gems."
    gem.imageName = "rose"
    gem.mainColor = "rose"
    gem.crystalSystem = "Hexagonal crystal system"
    gem.formula = "SiO₂"
    gem.hardness = "7"
    gem.transparency = "Translucent, Transparent"
    gem.timestamp = Date()
    return gem
  }

  static var lapisGem: Gem {
    let gem = Gem(context: PersistenceController.preview.container.viewContext)
    gem.name = "Lapis Lazuli"
		gem.info = """
		Lapis lazuli is a deep-blue rock used to create semiprecious stones and artifacts.
		Lapis Lazuli once terraformed planets for Homeworld.
		"""
    gem.imageName = "lapis"
    gem.mainColor = "blue"
    gem.crystalSystem = "Cubic crystal system"
    gem.formula = "(Na,Ca)₈Al₆Si₆O₂₄ (S,SO)₄"
    gem.hardness = "5 – 5.5"
    gem.transparency = "Opaque"
    gem.timestamp = Date()
    gem.favorite = true
    return gem
  }
}
