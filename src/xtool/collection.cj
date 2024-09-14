package cjweave.xtool

public interface CollectionPredicate<T> {
    static func isEmpty(elements: Option<Collection<T>>): Bool {
        return elements.isNone() || elements.getOrThrow().isEmpty()
    }

    static func isNotEmpty(elements: Option<Collection<T>>): Bool {
        return !CollectionPredicate.isEmpty(elements)
    }
}
