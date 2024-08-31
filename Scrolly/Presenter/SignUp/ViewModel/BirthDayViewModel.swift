//
//  BirthDayViewModel.swift
//  Scrolly
//
//  Created by 유철원 on 8/31/24.
//


import Foundation
import RxSwift
import RxCocoa

final class BirthDayViewModel: BaseViewModel, ViewModelProvider {
    
    var model: PostsModel?
    
    var builder: UserBuilder?
    
    private let disposeBag = DisposeBag()
    
    init(model: PostsModel? = nil, builder: UserBuilder? = nil) {
        super.init()
        self.model = model
        self.builder = builder
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    struct Input {
        let picekdDate: ControlProperty<Date>
        let nextTap: ControlEvent<Void>
    }
    
    struct Output {
        let pickedDate: Observable<String>
        let isValid: Driver<Bool>
        let nextTap: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output? {
        
        var dateSubjects: [String : BehaviorRelay<Int>] = [
            "year" : BehaviorRelay(value: 1920),
            "month" : BehaviorRelay(value: 1),
            "day" : BehaviorRelay(value: 1),
        ]
        
        let pickedDate = input.picekdDate
            .asDriver()
            .map {
                return Calendar.current.dateComponents([.year, .month, .day], from: $0)
            }
        
        pickedDate
            .drive(with: self) { owner, components in
                guard let year = components.year, let month = components.month, let day = components.day else {
                    return
                }
                dateSubjects["year"]?.accept(year)
                dateSubjects["month"]?.accept(month)
                dateSubjects["day"]?.accept(day)
            }
            .disposed(by: disposeBag)
        
        let outputDate = Observable.combineLatest(dateSubjects.sorted{ $0.key > $1.key }.map{ $0.value })
            .map { "\($0[0])년 \($0[1])월 \($0[2])일"}
        
        let isValid = pickedDate
            .map{ [weak self] pickedDate in
                guard let pickedDate = Calendar.current.date(from: pickedDate) else {
                    return false
                }
                let ageComponents = Calendar.current.dateComponents([.year,.month,.day], from: pickedDate, to: Date())
                let birthDay = "\(ageComponents.year).\(ageComponents.month).\(ageComponents.day)"
                
                guard ageComponents.year ?? 1 >= 17 else {
                    return false
                }
                self?.builder = self?.builder?.withBirthday(birthDay)
                return true
            }
        
        return Output(pickedDate: outputDate, isValid: isValid, nextTap: input.nextTap)
    }
    
}

