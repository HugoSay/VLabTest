//
//  CommentEntryViewController.swift
//  VLabsTest
//
//  Created by Hugo Saynac on 25/08/2019.
//  Copyright © 2019 HugoCorp. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CommentEntryViewController: UIViewController, UITextFieldDelegate {
    let bag = DisposeBag()
    @IBOutlet private weak var textInput: UITextField!
    @IBOutlet private weak var sendButton: UIButton!

    let commentPublisher = PublishSubject<String>()

    static func fromStoryboard() -> CommentEntryViewController {
        return UIStoryboard.init(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "CommentEntryViewController") as! CommentEntryViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 16
        textInput.delegate = self

        sendButton.rx.tap.bind(onNext: { [weak self] _ in
            self?.sendComment()
        }).disposed(by: bag)

        textInput.rx.text.asDriver()
            .map { !($0?.isEmpty ?? true) }
            .drive(sendButton.rx.isEnabled).disposed(by: bag)
    }

    private func sendComment() {
        guard let comment = textInput.text else { return }
        commentPublisher.onNext(comment)
        self.textInput.text = nil
        self.textInput.sendActions(for: .valueChanged) // lets listeners know that the text value was changed
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendComment()
        return false
    }

}
