import UIKit

class MainViewController: UICollectionViewController {

    let buttons = [
        // ( title, segue, button_color, text_color )
        ("title_download", "download", "red", "white"),
        ("title_context", "context", "green", "black"),
        ("title_associated", "associated", "blue", "white"),
        ("title_statemachine", "statemachine", "yellow", "black")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        fadeScreen()

        if let flow = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            let itemSpacing = CGFloat(10)
            let itemsInOneLine = CGFloat(2)
            flow.sectionInset = UIEdgeInsets(top: itemSpacing,
                                             left: itemSpacing,
                                             bottom: itemSpacing,
                                             right: itemSpacing)
            let width = view.bounds.size.width - itemSpacing*CGFloat(itemsInOneLine + 1)
            flow.itemSize = CGSize(width: floor(width/itemsInOneLine), height: width/itemsInOneLine)
            flow.minimumInteritemSpacing = itemSpacing
            flow.minimumLineSpacing = itemSpacing
        }
    }

    @IBAction func unwindToMainViewController(segue: UIStoryboardSegue) {
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let (_, segue, _, _) = buttons[indexPath.row]
        performSegue(withIdentifier: segue, sender: self)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return buttons.count
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mainCollectionViewCell",
                                                         for: indexPath) as? MainCollectionViewCell {
            let (title, _, button_color, text_color) = buttons[indexPath.row]
            cell.design = button_color
            cell.label.design = text_color
            cell.label.designTitle = title
            return cell
        }
        return UICollectionViewCell()
    }

}
