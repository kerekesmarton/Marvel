//
//  Presentation
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import Domain
import Presentation
import Data
import IosCore

public protocol LoginPresenting: class {
    func viewReady()
    func save()
    func signUpPressed()
}

public protocol LoginPresentingOutput: class {
    var inputPublicAction: Edit? { get set }
    var inputPrivateAction: Edit? { get set }
    var state: PresentationOutputState? { get set }
}

public protocol LoginRouting: Routing {
    func finish()
}

struct Credendials {
    var publicKey: String?
    var privateKey: String?
}

public final class LoginPresenter: LoginPresenting {
    
    //MARK: - Properties
    private let router: LoginRouting & ErrorRouting
    private var userRepository: UserProfileStoring
    private let config: Configurable
    
    public weak var view: LoginPresentingOutput?
    private var credentials = Credendials()
    var isValid: Bool {
        guard let publicKey = credentials.publicKey, let pivateKey = credentials.privateKey else { return false }
        return publicKey.count > 0 && pivateKey.count > 0
    }
    private var viewState: PresentationOutputState {
        didSet {
            view?.state = viewState
        }
    }
    
    
    
    //MARK: - Constructor
    public init(userRepository: UserProfileStoring,
                router: LoginRouting & ErrorRouting,
                config: Configurable) {
        self.userRepository = userRepository
        self.router = router
        self.config = config
        self.viewState = .disabled
    }
    
    //MARK: - LoginPresenting
    public func viewReady() {
        setupEditing()
    }
    
    public func save() {
        guard isValid else { return }
        userRepository.privateKey = credentials.privateKey
        userRepository.publicKey = credentials.publicKey
        
        router.finish()
    }
    
    //MARK: - Private methods
    private func setupEditing() {
        view?.inputPublicAction = { [weak self] text in
            self?.credentials.publicKey = text.trimmingCharacters(in: .whitespacesAndNewlines)
            self?.refreshViewState()
        }
        
        view?.inputPrivateAction = { [weak self] text in
            self?.credentials.privateKey = text.trimmingCharacters(in: .whitespacesAndNewlines)
            self?.refreshViewState()
        }
        
        viewState = .disabled
    }
    
    private func refreshViewState() {
        if isValid {
            viewState = .enabled
        } else {
            viewState = .disabled
        }
    }
    
    public func signUpPressed() {
        let signup: String = "https://developer.marvel.com/account"
        guard let url = URL(string: signup) else { return }
        router.route(url: url) { (success) in }
    }

}
