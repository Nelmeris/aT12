//
//  AuthService.swift
//  Travel Match
//
//  Created by Maxim Timokhin on 14.06.2020.
//  Copyright © 2020 Maxim Timokhin. All rights reserved.
//

import Foundation
import Core
import Auth

struct UserDefaultsUser: Codable, Identifiable, Authentificatable {
    let id: String
    let name: String
    let password: String
}

final class UserDefaultsAuthService: AuthService {

    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
    
    // MARK: - AuthService
    
    var isAuthorized: Bool {
        return currentUser != nil
    }
    
    var currentUser: Authentificatable? {
        get {
            try? userDefaults.get(
                objectType: UserDefaultsUser.self,
                forKey: "currentUser"
            )
        }
        set {
            try? userDefaults.set(
                object: newValue as? UserDefaultsUser,
                forKey: "currentUser"
            )
        }
    }
    
    func searchUser(
        byEmail email: String,
        completion: @escaping AuthSearchCompletion
    ) {
        do {
            let user = try userDefaults.get(
                objectType: UserDefaultsUser.self,
                forKey: email
            )
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                completion(.success(user))
            }
        } catch {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                completion(.failure(error))
            }
        }
    }
    
    func searchUser(
        byPhone email: String,
        completion: @escaping AuthSearchCompletion
    ) {
        
        do {
            let user = try userDefaults.get(
                objectType: UserDefaultsUser.self,
                forKey: email
            )
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                completion(.success(user))
            }
        } catch {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                completion(.failure(error))
            }
        }
    }
    
    func signInGuest(
        completion: @escaping AuthSignInCompletion
    ) {
        let user = UserDefaultsUser(
            id: "guest",
            name: "Guest",
            password: ""
        )
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.currentUser = user
            completion(.success(user))
        }
    }
    
    func signIn(
        userId: String,
        password: String,
        remember: Bool,
        completion: @escaping AuthSignInCompletion
    ) {
        do {
            if let user = try userDefaults.get(
                objectType: UserDefaultsUser.self,
                forKey: userId),
                user.password == password {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.currentUser = user
                    completion(.success(user))
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    completion(.failure(CoreError(message: "Пользователь не найден")))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    func signUp(
        email: String,
        password: String,
        name: String,
        completion: @escaping AuthSignInCompletion
    ) {
        let user = UserDefaultsUser(
            id: email,
            name: name,
            password: password
        )
        try? userDefaults.set(object: user, forKey: user.id)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.currentUser = user
            completion(.success(user))
        }
    }
    
    func signUp(
        phone: String,
        password: String,
        name: String,
        completion: @escaping AuthSignInCompletion
    ) {
        let user = UserDefaultsUser(
            id: phone,
            name: name,
            password: password
        )
        try? userDefaults.set(object: user, forKey: user.id)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.currentUser = user
            completion(.success(user))
        }
    }
    
    func logout(
        completion: @escaping AuthLogoutCompletion
    ) {
        currentUser = nil
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion(.success(true))
        }
    }
    
    func resetPasssword(phone: String, completion: @escaping AuthResetPasswordCompletion) {
        do {
            if (try userDefaults.get(
                objectType: UserDefaultsUser.self,
                forKey: phone)) != nil {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    completion(.success(true))
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    completion(.failure(CoreError(message: "Пользователь не найден")))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    func resetPasssword(email: String, completion: @escaping AuthResetPasswordCompletion) {
        do {
            if (try userDefaults.get(
                objectType: UserDefaultsUser.self,
                forKey: email)) != nil {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    completion(.success(true))
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    completion(.failure(CoreError(message: "Пользователь не найден")))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }

}
