
import CoreData

struct PersistenceController {
  static let shared = PersistenceController()

  let container: NSPersistentContainer

  init(inMemory: Bool = false) {
    container = NSPersistentContainer(name: "RayGem")
    if inMemory {
      container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
    }
    container.loadPersistentStores { _, error in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    }

    if isFirstTimeLaunch && !inMemory {
      let viewContext = container.viewContext
      createInitialGems(context: viewContext)

      do {
        try viewContext.save()
      } catch let dbError {
        let nsError = dbError as NSError
        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
      }
    }
  }
}

// MARK: - First Time Launch
extension PersistenceController {
  var isFirstTimeLaunch: Bool {
    guard UserDefaults.standard.bool(forKey: "first_time_launch") else {
      UserDefaults.standard.setValue(true, forKey: "first_time_launch")
      return true
    }
    return false
  }
}

// MARK: - Preview data
extension PersistenceController {
  static var preview: PersistenceController = {
    let result = PersistenceController(inMemory: true)
    let viewContext = result.container.viewContext
    for index in 0...5 {
      let even = index % 2 == 0
      let gem = Gem(context: viewContext)
      gem.name = even ? "Lapis Lazuli" : "Rose Quartz"
      gem.info = even ? "Terraformer" : "The most sought-after crystal gems"
      gem.imageName = even ? "lapis" : "rose"
      gem.mainColor = even ? "blue" : "rose"
      gem.crystalSystem = "Hexagonal crystal system"
      gem.formula = "SiO₂"
      gem.hardness = "7"
      gem.transparency = "Translucent, Transparent"
      gem.timestamp = Date()
    }
    do {
      try viewContext.save()
    } catch {
      let nsError = error as NSError
      fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
    }
    return result
  }()
}
