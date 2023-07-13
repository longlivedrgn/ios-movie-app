# 🍿 영화 앱

> 최신 영화의 순위 및 장르 별 영화를 찾아볼 수 있는 박스오피스 앱입니다☺️
> 

| 개발 인원 | 제작 기간 |
| --- | --- |
| 1인 개발 | 5.16 ~ 5.30(2주) |

# 🌳 목차
1. [📺 실행 화면](#-실행-화면)
2. [🏠 프로젝트 구조](#-프로젝트-구조)
3. [📚 Library](#-Library)
4. [🤨 고민과 해결](#-고민과-해결)

# 📺 실행 화면

| 홈화면 뷰 | 디테일 뷰 | 장르 뷰 |
| --- | --- | --- |
|<img src="https://github.com/longlivedrgn/ios-movie-app/assets/85781941/1bafa8d2-653a-439f-97e0-ff8d8e799466" width="250"/>|<img src="https://github.com/longlivedrgn/ios-movie-app/assets/85781941/ab1bfc3c-e898-410b-80fb-248a27002045" width="250"/>|<img src="https://github.com/longlivedrgn/ios-movie-app/assets/85781941/f304af30-9659-49d0-bb04-41bc9208a95c" width="250"/>|

| 서치 뷰 | 즐겨찾기 뷰 |
| --- | --- |
|<img src="https://github.com/longlivedrgn/ios-movie-app/assets/85781941/10e820c3-cbe6-48e2-8cdc-aaf51e34c509" width="250"/>|<img src="https://github.com/longlivedrgn/ios-movie-app/assets/85781941/002b45d7-c5ce-4752-9756-df9404d9b1ae" width="250"/>

# 🏠 프로젝트 구조
<img width="600" alt="image" src="https://github.com/longlivedrgn/ios-movie-app/assets/85781941/9f2d8bb7-65d6-40af-ab7f-831cbdf5d45a">

# 📚 Library

| **Autolayout** |
| --- |
| Snapkit |
- Autolayout을 잡아줄 때 사용되는 boilerplate 코드를 줄이기위하여 Snapkit 라이브러리를 활용했어요.

# 🤨 고민과 해결
  * [💥 하나의 datasource를 활용하여 서로 다른 API 데이터 모델 처리하기](#-하나의-datasource를-활용하여-서로-다른-api-데이터-모델-처리하기)
  * [💥 Collection View 레이아웃 짜기](#-collection-view-레이아웃-짜기)
  * [💥 가변적인 cell 구현하기](#-가변적인-cell-구현하기)
  * [💥 무거워진 view controller 덜어내기](#-무거워진-view-controller-덜어내기)
  * [💥 View controller의 순환 참조 문제](#-view-controller의-순환-참조-문제)

## 💥 하나의 datasource를 활용하여 서로 다른 API 데이터 모델 처리하기
<details>
<summary>📝 Please Open</summary>


 
⁉️ `DiffableDatasource`를 사용한 이유

- Home scene 속 상단 section은 인기 있는 영화 보여주고, 하단 section은 전체 영화를 장르 별로 나눴어요.
- 상단 section(이하 rank section)의 경우, header에 인기 상승 순, 영화 개봉 순 버튼을 두어 해당 기준을 통하여 영화들이 sorting이 되도록 구현을 해보았어요. 또한, 하단의 장르별 영화 section(이하 genre section)의 경우에도, 더보기 버튼을 눌러 숨겨진 나머지 셀들을 보여주도록 구현을 해보았어요.
- **기존에는 reloadData를 활용하여 controller가 변경사항을 UI에게 알려주는 동기화 작업을 해주었어요. 그러나, 해당 프로젝트에서는 레이아웃 UI가 빈번하게 변경되며 애니메이션이 자동으로 적용되지 않는 reloadData를 활용하여 동기화를 진행할 경우,  사용자 UX 경험이 떨어질 수 있다고 판단이 들었기에 DiffableDatasource를 활용했어요.**

Diffabledatasource의 경우, 하나의 collection view에서 하나의 item identifier 타입을 가지고 있어요. 각각의 섹션은 서로 다른 API 호출을 하므로, 다른 데이터 모델을 가지고 하나의 datasource item identifier 타입을 만들어줘야했어요. 다음은 제가 해당 문제를 해결하기 위해서 고민했던 과정이에요.

### 1️⃣ 두 가지의 모델을 묶어줄 수 있는 하나의 Item Identifier 타입 생성하기

- 저는 두 API를 통해서 받아온 데이터 모델을 합친 Movie 타입을 만들어서 item identifier 타입으로 활용하려고 했어요.
- 그리고, 아래와 같이 서로 다른 section에 items들을 append하도록 로직을 구현했어요.

```swift
// 🍿 in HomeViewController
private var datasource: DataSource?
// ✅ Rank Section
private var movies = [Movie]() {
    didSet {
        applySnapShot()
    }
}
// ✅ genre Section
private var genres = [Movie]() {
    didSet {
        applySnapShot()
    }
}
private func applySnapShot() {
        var snapShot = SnapShot()
        snapShot.appendSections([.rank])
        snapShot.appendItems(movies)

        snapShot.appendSections([.genre])
        snapShot.appendItems(genres)

        self.datasource?.apply(snapShot)
    }
}
```

- 이렇게 구현할 경우, 원하는 대로 서로 다른 타입의 데이터 모델을 하나의 diffable datasource를 활용하여 collection view에 구현할 수 있었어요.
- 그러나, 둘을 합친 model(item identifier)은 optional이 난무했고, 불필요한 코드들이 많이 생기게 되었어요.

### 2️⃣  프로토콜을 활용하여 item identifier 타입 구현하기

- 담고 싶은 데이터 타입을 `ItemIdenfiable` 프로토콜을 채택하도록 해요.

```swift
// 💥 ItemIdenfiable 프로토콜 정의
protocol ItemIdenfiable {
    var identity: UUID { get set }
}

// 💥 프로토콜을 채택한 MovieGenre 타입 정의
struct MovieGenre: ItemIdenfiable {
    var identity = UUID()
		...
}

// 💥 프로토콜을 채택한 Movie 타입 정의
struct Movie: ItemIdenfiable {
    var identity = UUID()
		...
}
```

- `ItemIdenfiable` 한 프로퍼티를 가지고 있는 ItemType 구조체를 정의하여 diffable datasource의 item identifier 타입으로 활용하는 방식이에요.

```swift
// 💥 Item identifier 타입 구현
private struct ItemType: Hashable {

    var item: any ItemIdenfiable

    static func == (lhs: MovieHomeViewController.ItemType, rhs: MovieHomeViewController.ItemType) -> Bool {
        return lhs.item.identity == rhs.item.identity
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(item.identity)
    }

}

private typealias DataSource = UICollectionViewDiffableDataSource<Section, ItemType>
```

- 아래와 같이 ItemType으로 `ItemIdenfiable` 을 채택한 데이터 모델을 감싸서 items로 append해요.

```swift
private func applySnapShot() {
        var snapShot = SnapShot()
        snapShot.appendSections(Section.allCases)

        var rankMovies = movieHomeController.movies
        let movieItems = rankMovies.map { ItemType(item:$0) }
        snapShot.appendItems(movieItems, toSection: .rank)

        var allGenres = movieHomeController.genres
        let genreItems = allGenres.map { ItemType(item: $0) }
        snapShot.appendItems(genreItems, toSection: .genre)

        datasource?.apply(snapShot)
}
```

### 2️⃣ enum의 연관 값을 활용하여 Item 타입 구현하기

- 그러던 중, 애플 공식문서 속 예제 코드에서 서로 다른 item들을 하나의 타입으로 감싸서 활용하는 코드를 보았어요
- 이를 참고하여 저도 하나의 enum 타입으로 서로 다른 section에 활용되는 데이터 모델을 묶고, 각각의 모델을 enum의 연관 값으로 넣어주는 방법으로 구현해보기로 했어요.

```swift
private struct SidebarItem: Hashable {
        let title: String
        let type: SidebarItemType

        enum SidebarItemType {
            case standard, collection, expandableHeader
        }
}

private func createSnapshotOfRecipeCollections() -> NSDiffableDataSourceSectionSnapshot<SidebarItem> {
        let items = recipeSplitViewController.recipeCollections.map { SidebarItem(title: $0, type: .collection) }
        return createSidebarItemSnapshot(.recipeCollectionItems, items: items)
}
```

- 연관 값으로 내가 담고 싶은 데이터 모델 타입을 가질 수 있는 `item` 열거형 타입 정의해요.

```swift
private enum Item: Hashable {
    case rank(Movie)
    case gerne(MovieGenre)
}

private typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
```

- 아래와 같이 enum의 연관 값으로 데이터 모델을 넣어서 item identifier 타입을 구현해요.

```swift
private func applySnapShot() {
    var snapShot = SnapShot()
    snapShot.appendSections(Section.allCases)

    var rankMovies = movieHomeController.movies
		// 💥 연관 값 넣어주기
    let movieItems = rankMovies.map { Item.rank($0) }

    var allGenres = movieHomeController.genres
    snapShot.appendItems(movieItems, toSection: .rank)

		// 💥 연관 값 넣어주기
    let genreItems = allGenres.map { Item.gerne($0) }
    snapShot.appendItems(genreItems, toSection: .genre)

    datasource?.apply(snapShot)
}

```

💬 2,3번 방법 모두 다, Hashable을 만족하는 타입으로 넣고 싶은 데이터 모델을 래핑했다는 공통점이 있어요.

- 2번째 protocol 방법의 경우, DIP 법칙을 만족하여 `ItemIdentifiable` 프로토콜을 채택한 어떤 모델이든 item identifier가 될 수 있으므로 손쉽게 section이 추가될 때마다 item 타입을 추가할 수 있어요.
- 3번째 enum의 연관 값을 활용한 경우, 섹션이 추가될 경우, case만 추가해주면 손쉽게 item 타입을 추가할 수 있어요.

➡️ 두 가지 방법 다 장점이 존재하지만, enum을 활용한 방법이 case를 통하여 한눈에 활용된 item type이 보인다는 점과, cell 재사용 시 분기처리에서 불필요한 default 케이스를 써주지 않아도 된다는 점에서 해당 프로젝트에서는 enum 케이스를 활용하여 item identifier 타입을 구현했어요.

</details>

## 💥 Collection View 레이아웃 짜기

<details>
<summary>📝 Please Open</summary>


 
- 저는 상단에 영화 정보를 띄어주는 부분(이하 detail view)과 하단의 영화인 정보를 보여주는 부분(이하 credits view)을 compositonal layout으로 구현하기 위하여 네 가지 방법을 고민해보았어요.

1. Detail view 아래 collection view 넣기
2. Header View를 활용해서 Detail View를 구현하기
3. Scroll view안에 detail view와 collection view 넣기
4.  Detail view를 첫 번째 section에, credit view를 두 번째 section으로 넣기

### 1️⃣ Detail view 아래 collection view 넣기 ❌

<img width="500" alt="image" src="https://github.com/longlivedrgn/ios-movie-app/assets/85781941/08c44040-3cf2-4179-a08e-186818eacc22">

- 가장 먼저 생각했던 방법이었는데, 이렇게 구현할 경우, 전체 화면이 scroll 되지 않고 credit view만 가로로 스크롤되는 문제가 발생했어요. 따라서 두 번째 방법을 생각하게되었어요.

### 2️⃣ Header View를 활용해서 Detail View를 구현하기 ❌
<img width="500" alt="image" src="https://github.com/longlivedrgn/ios-movie-app/assets/85781941/9c9d1469-5787-482d-bbac-573cc8d4898f">


- 전체를 하나의 section으로 구현하여 Detail view를 headerview로 구현하려고 했어요. Detail view 밑에 감독 및 등장인물이라는 section header가 존재하므로 두 개의 header를 가지게 되는 레이아웃이었어요. Table view의 경우, 두 개의 header view를 구현하는 것이 자연스럽지만, collection view의 경우 2개의 header view를 가지는 것이 어색했어요. 그래서 더 좋은 방식이 있지 않을까 고민하게되었어요.

### 3️⃣ Scroll view안에 detail view와 collection view 넣기 ✅

<img width="500" alt="image" src="https://github.com/longlivedrgn/ios-movie-app/assets/85781941/f9ff60e5-c73d-43d9-b915-68c1281316eb">


- collection view는 scroll view를 상속 받는 타입이에요. 따라서 위와 같이 구현하면 scroll view 안에 scroll view를 넣게되요. 애플의 HIG 문서를 참고해본 결과, 중첩 scroll view를 지양하라고 했지만, 서로 다른 방향의 scroll view의 중첩은 문제가 되지 않음을 알게되었어요. 그러나, scroll view를 활용해서 생기는 까다로운 레이아웃 잡기 과정을 피하고 싶어 4번째 방법을 생각하게됐어요.

> **Avoid putting a scroll view inside another scroll view with the same orientation.** Doing so creates an unpredictable interface that’s difficult to control. It’s alright to place a horizontal scroll view inside a vertical scroll view (or vice versa), however.
> 

### 4️⃣ Detail view를 첫 번째 section에, credit view를 두 번째 section으로 넣기 ✅

<img width="500" alt="image" src="https://github.com/longlivedrgn/ios-movie-app/assets/85781941/defdf0e8-46a1-4e31-8680-8e3f1c326804">

- 첫 번째 section에는 detail view cell 하나만을 보여주고, 두 번째 section에서는 credit view를 보여주는 방식으로 구현을 했어요. 해당 방법을 활용하니, 전체 화면이 scroll이 되면서 원하는 layout을 구현할 수 있었어요.

</details>

## 💥 가변적인 cell 구현하기
<details>
<summary>📝 Please Open</summary>


- feat. cell안에 버튼 넣기

| 디테일 뷰 |
| --- |
|<img src="https://github.com/longlivedrgn/ios-movie-app/assets/85781941/ab1bfc3c-e898-410b-80fb-248a27002045" width="250"/>|

- Detail view안에 더보기 버튼을 추가하여 버튼을 누르면 label의 numberOfLines가 변경되어, cell의 height가 늘어나는 동적인 cell을 만드려고 했어요.
- Delegate 패턴을 통하여 button 탭이 되면, view controller가 label의 numberOfLines를 변경하고, button의 타이틀을 변경하도록 구현했어요.

```swift
// 🌈 delegate 패턴 활용!
protocol MovieDetailFirstSectionViewDelegate: AnyObject {
    func movieDetailFirstSectionView(
        _ movieDetailFirstSectionView: MovieDetailFirstSectionView,
        didButtonTapped sender: UIButton
    )
}
```

- 또한 NSCollectionLayoutSection을 구현하는 코드에서 itemsize 및 groupsize를 `.fractional`이나 `.absolute`가 아닌 `.estimated`을 통하여 구현했어요. 또한, view안의 layout을 기존의 `equalTo`가 아닌 `greaterThanEqual`등으로 구현을 해주었어요.

```swift
// 🍿 in MovieDetailViewController
private func createDetailLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
						// 💦 .estimated 활용
            heightDimension: .estimated(600)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(600)
        )

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)

        return section
    }
```
</details>


## 💥 무거워진 view controller 덜어내기
<details>
<summary>📝 Please Open</summary>

 
- MVC 구조로 로직을 짜다보니, view controller가 많이 무거워졌어요. View controller는 collection view를 구현하는 다양한 로직과 다른 delegate을 채택한 다양한 메소드가 존재했어요. 또한, Networking을 하며 필요한 data를 받아오는 로직 또한 view controller가 관장하고 있었어요.
- 저는 너무 커진 view controller의 역할을 줄이기 위하여 controller라는 모델 타입을 생성했어요. 해당 타입은 MVC 구조에서 Model의 역할이며 데이터와 관련된 내용 및 로직을 가지고 있지만, UI와는 직접적으로 연결되지 않아요. 즉, Model 타입은 view controller를 모르지만, view controller는 model을 내부 프로퍼티로 가지고 있어요.
- Model은 API 통신을 통하여 view controller가 collection view에 띄울 때 활용하는 데이터 모델 타입을 생성해요. 그리고 model 타입을 완성하면 observer 패턴을 통하여 view controller에게 model이 완성되었음을 알려주고, view controller는 해당 model을 통하여 collection view를 띄우게 돼요.

🔊 `Controller` - MovieDetailController

```swift
final class MovieDetailModel {

    private let movie: Movie
		// 🌟 네트워크 객체
    private let movieNetworkAPIManager = NetworkAPIManager()
    private let movieNetworkDispatcher = NetworkDispatcher()

   ...

    private func fetchMovieDetails() {
				// 🔥 데이터  모델 생성
        guard let movieID = movie.ID else { return }
        let movieDetailEndPoint = MovieDetailsAPIEndPoint(movieCode: movieID)
        let movieCertificationEndPoint = MovieCertificationAPIEndPoint(movieCode: movieID)
        Task {
            do {
               ....
                }
            } catch {
							 ....
            }
            NotificationCenter.default.post(
                name: NSNotification.Name("MovieDetailModelDidFetchCreditData"),
                object: nil
            )
        }
    }
```

🔊 `ViewController` - MovieDetailViewController

```swift
// 🍿 in configureNotificationCenter()
NotificationCenter.default.addObserver(
    self,
    selector: #selector(didFetchMovieCreditsData(_:)),
    name: NSNotification.Name("MovieDetailModelDidFetchCreditData"),
    object: nil
)
// 🍿 in MovieDetailViewController
@objc private func didFetchMovieCreditsData(_ notification: Notification) {
        DispatchQueue.main.async {
            self.movieDetailCollectionView.reloadSections([Section.credit.rawValue])
        }
    }
```

💬 이를 통해서, view controller는 view와 관련 없는 코드를 덜어낼 수 있었고, view controller의 역할이 많아져서 떨어지던 코드의 가독성 개선할 수 있었어요.


</details>

## 💥 View controller의 순환 참조 문제

<details>
<summary>📝 Please Open</summary>

 
- 해당 앱은 NotificationCenter를 활용하여 view를 업데이트하는 로직을 활용해요.
- 그리고 navigation controller를 활용하여 push가 되고 pop이되면 pop된 view controller는 자동으로 deinit이 되면서 NotificationCenter가 자동으로 remove가 돼요.

아래의 애플 공식문서를 읽어보면 개발자가 직접적으로 NotificationCenter를 remove하지 않아도 됨을 알 수 있어요.

[애플 공식문서](https://developer.apple.com/documentation/foundation/notificationcenter/1415360-addobserver)

> Unregister an observer to stop receiving notifications.
To unregister an observer, use removeObserver(*:) or removeObserver(*:name:object:) with the most specific detail possible. For example, if you used a name and object to register the observer, use the name and object to remove it.
**If your app targets iOS 9.0 and later or macOS 10.11 and later, you do not need to unregister an observer that you created with this function. If you forget or are unable to remove an observer, the system cleans up the next time it would have posted to it.**
> 

- 그러나, 프로젝트 진행 중 Notification이 중복으로 받아지는 경우를 확인했어요.
    - Home viewcontroller에서 detail viewcontroller로 넘어갈 때, NotificationCenter를 addObserver를 하는 데, detail view controller가 pop될 때에 Notification center가 remove가 되지 않으므로, 계속해서 Notification이 중복으로 받아지는 것이었어요.

**🖐️ 위와 같은 상황이 일어나는 이유는 detail view controller가 pop될 때, view controller 속 클로져나 delegate 변수에 의해서 순환참조가 일어나 메모리에서 할당 해제(deinit)이 되지 않기 때문이었어요.**

- 따라서 아래와 같이 약한 참조(weak)를 활용하여 view controller가 pop될 때, 메모리에서 할당 해제가 될 수 있게 변경해주었어요.

```swift
private func createlayout() -> UICollectionViewCompositionalLayout {
    let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnvironment in
        let sectionType = Section.allCases[sectionIndex]
        switch sectionType {
        case .detail:
            return self?.createDetailLayout()
        case .credit:
            return self?.createCreditLayout()
        }
    }
    return layout
}
```

💬 이를 통해서, pop될 때, 정상적으로 view controller가 메모리에서 할당 해제가 되어 Notification이 중복으로 받아지는 문제를 해결할 수 있었어요.

</details>

