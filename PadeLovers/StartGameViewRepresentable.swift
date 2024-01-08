//
//  StartGameViewRepresentable.swift
//  PadeLovers
//
//  Created by Yoshitaka Tanaka on 2024/01/07.
//  Copyright © 2024 Yoshitaka. All rights reserved.
//

import SwiftUI
import Combine

struct StartGameView: View {
    @Binding var path: [HomeView.Screen]
    @ObservedObject var viewModel = StartGameViewModel()

    var body: some View {
        VStack {
            StartGameViewRepresentable(groupID: $viewModel.groupID, padelID: $viewModel.padelID)
        }
        .onReceive(Just(viewModel.padelID)) { padelID in
            guard let padelID else { return }
            path.append(.gameStartDefault(groupID: nil, padelID: padelID))
        }
        .confirmationDialog("モード選択", isPresented: $viewModel.showOption) {
            if let groupID = viewModel.groupID {
                NavigationLink(value: HomeView.Screen.gameStartDefault(groupID: groupID)) {
                    Text("標準モード")
                }
                NavigationLink(value: HomeView.Screen.gameStartMix(groupID: groupID)) {
                    Text("簡易モード")
                }
            }
        } message: {
            Text("詳しい説明")
        }
    }
}

final class StartGameViewModel: ObservableObject {
    @Published var showOption = false
    @Published var groupID: String?
    @Published var padelID: UUID?

    var cancellables = Set<AnyCancellable>()

    init() {
        $groupID
            .sink { [weak self] groupID in
                guard groupID != nil else { return }
                self?.padelID = nil
                self?.showOption = true
            }
            .store(in: &cancellables)
    }
}

#Preview {
    StartGameView(path: .constant([]))
}

struct StartGameViewRepresentable: UIViewControllerRepresentable {
    @Binding var groupID: String?
    @Binding var padelID: UUID?

    func makeUIViewController(context: Context) -> UIViewController {
        let storyboard = UIStoryboard(name: "StartGame", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "StartGame") as! StartGameTableViewController
        viewController.delegate = context.coordinator
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, StartGameTableViewControllerDelegate {
        var viewController: StartGameViewRepresentable

        init(_ viewController: StartGameViewRepresentable) {
            self.viewController = viewController
        }

        func callBackFromStartGameModalVC(groupID: String?, padelID: UUID?) {
            if let groupID {
                viewController.groupID = groupID
            }
            if let padelID {
                viewController.padelID = padelID
            }
        }
    }
}
