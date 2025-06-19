# Restarted

Мой бакалавский проект для [UTB](https://www.utb.cz/en/), написан и защищен с отличием.  
- Frontend - Swift, SwiftUI
- Backend - Firebase Firestore
- Архитектура - MVVM

Приложение является централизованным инструментом для мониторинга игрового времени. 

## Основные функции
- Авторизация
- Отслеживание времени в практиках и играх
- Статьи о видеоигровой зависимости и контроле времени в играх
- Статистика времени

## Дополнительные функции 
- Смена языка
- Смена оформления
- Тесты на видеоигровую зависимость

### Авторизация
Авторизация реализована с `Firebase Auth`. Есть возможность авторизации через электронную почту и Google аккаунт.
Проверка входных данных проходит с помощью регулярного выражения:

```Swift

let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

```

<img width="278" alt="image" src="https://github.com/user-attachments/assets/7756532b-8d6f-411a-8d8b-cefc1ad9a92c" />

### Отслеживание времени в практиках и играх

Логика секций секций и игр в целом одинаковая. По сути различие только одно - в играх есть дополнительная механика пресетов, которая сохраняет последние запуски таймеров в список для большего удобства.

Модель представляет собой класс `Practice` / `GameFirestore`. Он содержит в себе все данные о объектах.

Объектами управляет класс `PracticeManager` / `GameManager`. Он содержит в себе методы для CRUD (Create, Delete, Update, Delete) операций и локику создания коллекций / докуменитов с объектами в `Firestore`.

Передачей данных с экранов `PracticeMainScreenView` и `GameMainScreenView` занимаются `PracticeViewModel` и `GameViewModel` соответственно.

<img width="278" alt="image" src="https://github.com/user-attachments/assets/1fe5b9ad-976a-4450-8b3d-7323069e4c7d" />

### Статьи о видеоигровой зависимости и контроле времени в играх
Для статей предусмотрена отдельная папка в `Firestore`, когда создается новый пользователь, эта папка автоматически копируется в директорию пользователя. 

Стаьи разделены на 2 уровня сложности - для начинающих и продвинутых пользователей. 

Статьи можно помечать как прочитанные, информация об этом сохранится в датабазе.

<img width="278" alt="image" src="https://github.com/user-attachments/assets/a8fff834-b26a-4213-80a3-28f6c29ee0cf" />

### Статистика

Данные для статистики берутся из классов `PracticeManager`, `GameManager`, сама статистика вычисляется на устройстве. 

Для отображиния статистики необходимо иметь минимум 3 экземпляра практик или игр.

<img width="278" alt="image" src="https://github.com/user-attachments/assets/b94dced7-024a-4c3e-ad16-a511a28f1452" />

### Смена языка

Смена языка происходит с помощью `Locale` и сохраняются в `UswrDefaults`.

Сами переводы храняться в `String Catalog`.

```Swift

final class LanguageManager: ObservableObject {
    @Published var locale: Locale
    
    init() {
        let savedCode = UserDefaults.standard.string(forKey: "AppLanguageCode")
        
        if let code = savedCode {
            self.locale = Locale(identifier: code)
        } else {
            self.locale = Locale.current
        }
    }
    
    func updateLanguage(to code: String) {
        UserDefaults.standard.set(code, forKey: "AppLanguageCode")
        
        self.locale = Locale(identifier: code)
    }
}

```

![Screenshot 2025-06-19 at 14 37 04](https://github.com/user-attachments/assets/d57d2e04-1aff-443d-9df4-c2047fbae6c6)

### Смена темы

Смена темы реализована с помощью перечисления `Theme` и изменения значения свойства `setTheme`.

```Swift

enum Theme: String, CaseIterable {
    case systemDefault = "systemDefault"
    case light = "lightTheme"
    case dark = "darkTheme"
    
    var localizedTitle: LocalizedStringKey {
        LocalizedStringKey(rawValue)
    }
    
    var setTheme: ColorScheme? {
        switch self {
        case .systemDefault: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
}

```

Информация о теме инициализируется в корневом файле `RestartedApp.swift`.

```Swift

@AppStorage("userTheme") private var userTheme: Theme = .systemDefault

```

![Screenshot 2025-06-19 at 14 48 03](https://github.com/user-attachments/assets/f58dfb71-6040-4c41-af2b-e9252bf44748)

### Тесты на видеоигровую зависимость

Тесты представлены в большой и короткой версиях и являются репрезентацией тестов IDG-20 и IGDS9-SF соответственно.

Результаты о тестировании высчитываются на устройстве и удаляются в момент закрытия теста.

<img width="278" alt="image" src="https://github.com/user-attachments/assets/7e0185b6-83b0-4ddd-af7b-a727068a7deb" />



