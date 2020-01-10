//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import Foundation
import Domain
import IosCore
import MarvelAuth
import MarvelCharacters
import MarvelSeries

class DependencyInjection {
    
    func injectDependencies(in container: ApplicationModules) {
        
        container.add(AppModule())
        
        // MARK: - Settings
        container.add(SettingsModule())
        
        //MARK: - Image handlers
        container.add(ImagePickerModule())
        container.add(ImageEditModule())
        container.add(ImageGalleryModule())
        container.add(MediaConvertingModule())
        
        
        container.add(CredentialsModule())
        
        container.add(TextModule())
        
        container.add(CharacterListModule(id: "character-list", tab: 1))
        container.add(CharacterModule())
        
        container.add(SeriesListModule(id: "series-list", tab: 2))
    }
}
