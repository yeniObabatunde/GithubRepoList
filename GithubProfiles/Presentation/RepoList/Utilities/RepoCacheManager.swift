//
//  RepoCacheManager.swift
//  GithubProfiles
//
//  Created by Sharon Omoyeni Babatunde on 01/01/2025.
//

import Foundation

final class RepoCacheManager {
    static let shared = RepoCacheManager()
    private let fileManager = FileManager.default
    private let cacheDirectory: URL
    
    private init() {
        let urls = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        cacheDirectory = urls[0].appendingPathComponent("GithubRepoCache")
        createCacheDirectoryIfNeeded()
    }
    
    private func createCacheDirectoryIfNeeded() {
        guard !fileManager.fileExists(atPath: cacheDirectory.path) else { return }
        try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
    }
    
    func cacheRepositories(_ repositories: [RepoItem]) {
        let cacheFile = cacheDirectory.appendingPathComponent("repositories.cache")
        do {
            let data = try JSONEncoder().encode(repositories)
            try data.write(to: cacheFile)
        } catch {
            print("Error caching repositories: \(error)")
        }
    }
    
    func getCachedRepositories() -> [RepoItem]? {
        let cacheFile = cacheDirectory.appendingPathComponent("repositories.cache")
        guard fileManager.fileExists(atPath: cacheFile.path) else { return nil }
        
        do {
            let data = try Data(contentsOf: cacheFile)
            return try JSONDecoder().decode([RepoItem].self, from: data)
        } catch {
            print("Error reading cached repositories: \(error)")
            return nil
        }
    }
    
    func clearCache() {
        try? fileManager.removeItem(at: cacheDirectory)
        createCacheDirectoryIfNeeded()
    }
}
