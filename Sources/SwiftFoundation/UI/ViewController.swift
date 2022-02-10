
#if !os(macOS)
import UIKit

open class ViewController: UIViewController {

   public let contentView: View 
   private let layoutUntil = DispatchUntil()
   private let setupConstraintsOnce = DispatchOnce()
   private var isInitiatedFromCoder = false
   private var supportedInterfaceOrientationsValue: UIInterfaceOrientationMask?

   open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
      return supportedInterfaceOrientationsValue ?? super.supportedInterfaceOrientations
   }

   open override func loadView() {
      super.loadView()
      if !isInitiatedFromCoder {
         view = contentView
         contentView.backgroundColor = .white
      }
   }

   public init(view: View) {
      contentView = view
      super.init(nibName: nil, bundle: nil)
   }

   public init() {
      contentView = View()
      super.init(nibName: nil, bundle: nil)
   }

   public required init?(coder: NSCoder) {
      contentView = View()
      isInitiatedFromCoder = true
      super.init(coder: coder)
   }

   open override func viewDidLayoutSubviews() {
      super.viewDidLayoutSubviews()
      layoutUntil.performIfNeeded {
         setupLayoutDefaults()
      }
   }

   open override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
   }

   open override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      layoutUntil.fulfill()
      view.assertOnAmbiguityInSubviewsLayout()
   }

   open override func viewDidLoad() {
      super.viewDidLoad()
      fetchData()
      setupStackViews()
      setupUI()
      setupDataSource()
      setupHandlers()
      setupDefaults()
      applyFixForUnsatisfiableConstraintsIfNeeded()
   }

   open override func viewWillLayoutSubviews() {
      super.viewWillLayoutSubviews()
      setupConstraintsOnce.perform {
         setupLayout()
      }
   }

   open override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      // Below fix is disabled because it wasn't working on my side.
      // I ended up with UIBarButtonItem with custom view (UIButton) inside.
      // applyBarButtonsTintIssueFix()
   }
    
    @objc open dynamic func fetchData() {
       // Base class does nothing.
    }
    
   @objc open dynamic func setupStackViews() {
      // Base class does nothing.
   }

   @objc open dynamic func setupUI() {
      // Base class does nothing.
   }

   @objc open dynamic func setupLayout() {
      // Base class does nothing.
   }

   @objc open dynamic func setupHandlers() {
      // Base class does nothing.
   }

   @objc open dynamic func setupDefaults() {
      // Base class does nothing.
   }

   @objc open dynamic func setupDataSource() {
      // Base class does nothing.
   }

   @objc open dynamic func setupLayoutDefaults() {
      // Base class does nothing.
   }

   public final func setSupportedInterfaceOrientations(_ value: UIInterfaceOrientationMask?) {
      supportedInterfaceOrientationsValue = value
   }
}

extension ViewController {

   private func applyFixForUnsatisfiableConstraintsIfNeeded() {
//      let subviewsSizes = view.recursiveSubviews.map { $0.frame.size }.sorted { $0 < $1 }
//      if let biggestSize = subviewsSizes.last, view.frame.size < biggestSize {
//         view.frame = CGRect(origin: view.frame.origin, size: biggestSize)
//      }
   }

   private func applyBarButtonsTintIssueFix() {
      // https://stackoverflow.com/a/48001648/1418981
      // Workaround for bug: UINavigationBar button remains faded after segue back.
      // Alternative solution: https://stackoverflow.com/a/47839657/1418981
      if #available(iOS 11.2, *) {
         navigationController?.navigationBar.tintAdjustmentMode = .normal
         navigationController?.navigationBar.tintAdjustmentMode = .automatic
      }
   }
}
#endif
