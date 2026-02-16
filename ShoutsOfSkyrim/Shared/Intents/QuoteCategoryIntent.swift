import AppIntents
import WidgetKit

struct QuoteCategoryIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Select Category"
    static var description: IntentDescription = "Choose a quote category for your widget."

    @Parameter(title: "Category", default: .all)
    var category: QuoteCategoryAppEnum
}
