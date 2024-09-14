package cjweave.xtool

public interface OptionPredicate<T> {
    static func isEmpty(element: Option<T>): Bool {
        return element.isNone()
    }

	static func isNotEmpty(element: Option<T>): Bool {
        return !element.isNone()
    }
}
