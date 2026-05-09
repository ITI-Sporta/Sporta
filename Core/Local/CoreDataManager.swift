//
//  CoreDataManager.swift
//  Sporta
//
//  Created by Hossam on 09/05/2026.
//

import Foundation
import CoreData

class CoreDataManager : DatabaseProtocol {
    
    static let shared = CoreDataManager()
    
    private init() {}
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Sporta")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load Core Data -> \(error.localizedDescription)")
            }
        }
        return container
    }()
    
    private var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    private func fetchFavoriteLeagueEntity(by id: Int) -> FavoriteLeagueEntity? {
        let request: NSFetchRequest<FavoriteLeagueEntity> = FavoriteLeagueEntity.fetchRequest()
        
        request.predicate = NSPredicate(format: "id == %id", Int64(id))
        request.fetchLimit = 1
        
        do {
            return try context.fetch(request)[0]
        } catch {
            print(error)
            return nil
        }
    }
    
    func getFavoriteLeague(by id: Int) -> FavoriteLeague? {
        return fetchFavoriteLeagueEntity(by: id)?.toUiModel()
    }
    
    func isFavoriteLeague(id: Int) -> Bool {
        return getFavoriteLeague(by: id) != nil
    }
    
    func deleteFavoriteLeague(by id: Int) -> Bool {
        guard let entity = fetchFavoriteLeagueEntity(by: id) else {
            return true
        }
        context.delete(entity)
        do {
            try context.save()
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    func getAllFavoriteLeagues() -> [FavoriteLeague] {
        let request : NSFetchRequest<FavoriteLeagueEntity> = FavoriteLeagueEntity.fetchRequest()
        do {
            return try context.fetch(request).compactMap{ entity in
                entity.toUiModel()
            }
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func addFavoriteLeague(_ league: FavoriteLeague) -> Bool {
        guard getFavoriteLeague(by: league.id) == nil else {
            return true
        }
        let entity = FavoriteLeagueEntity(context: context)
        
        entity.id = Int64(league.id)
        entity.name = league.name
        entity.country = league.country
        entity.logo = league.logo
        entity.countryLogo = league.countryLogo
        entity.sport = league.sport.rawValue
        
        do {
            try context.save()
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
}

extension FavoriteLeagueEntity {
    func toUiModel() -> FavoriteLeague? {
        guard
            let name = name,
            let country = country,
            let logo = logo,
            let countryLogo = countryLogo,
            let sportRaw = sport,
            let sport = Sport(rawValue: sportRaw) else {
                print("Favorite entity mapping error!")
            return nil
        }
        return  FavoriteLeague(id: Int(id), name: name, country: country, logo: logo, countryLogo: countryLogo, sport: sport)
    }
}
