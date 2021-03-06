public abstract class Maybe implements Monad {
    public static final Maybe Nothing = new Nothing();

    public static Maybe Just(Object value) {
        return new Just(value);
    }

    public static Maybe of(Object value) {
        return value == null ? Nothing : Just(value);
    }

    public static Function1 ofFunction() {
        return new OfFunction();
    }

    public abstract Maybe fmap(Function1 function);

    public Maybe pure(Object arg) {
        return Maybe.of(arg);
    }

    public Maybe apply(Applicative ap) {
        return apply((Maybe) ap);
    }

    public abstract Maybe apply(Maybe ap);

    public abstract Maybe liftA2(Function2 mergeFn, Applicative arg2);

    public abstract Maybe bind(Function1 aToMonadB);

    public Boolean isPresent() {
        return this instanceof Just;
    }

    public abstract Object getOrDefault(Object defaultValue);

    public abstract Object getOrError();

    public abstract Maybe orElseJust(Object valueInJust);

    public abstract Maybe filter(Function1 predicate);

    public class Nothing extends Maybe {
        Nothing() {}

        public override String toString() {
            return 'Nothing';
        }

        public Integer hashCode() {
            return 0;
        }

        public override Maybe fmap(Function1 function) {
            return this;
        }


        public override Maybe apply(Maybe ap) {
            return this;
        }

        public override Maybe liftA2(Function2 mergeFn, Applicative arg2) {
            return this;
        }

        public override Maybe bind(Function1 aToMonadB) {
            return this;
        }

        public override Object getOrDefault(Object defaultValue) {
            return defaultValue;
        }

        public override Object getOrError() {
            throw new NoSuchElementException('Missing value in Nothing type');
        }

        public override Maybe orElseJust(Object valueInJust) {
            return Maybe.of(valueInJust);
        }

        public override Maybe filter(Function1 predicate) {
            return Nothing;
        }
    }

    public class Just extends Maybe {
        final Object value;

        Just(Object value) {
            this.value = value;
        }

        public override String toString() {
            return 'Just{' + value + '}';
        }

        public Boolean equals(Object obj) {
            if (!(obj instanceof Maybe.Just)) {
                return false;
            }

            return System.equals(value, ((Maybe.Just)obj).value);
        }

        public Integer hashCode() {
            return System.hashCode(value);
        }

        public override Maybe fmap(Function1 function) {
            return Maybe.of(function.apply(value));
        }

        public override Maybe apply(Maybe ap) {
            return (ap instanceof Nothing)
                    ? Nothing
                    : ap.fmap((Function1)value);
        }

        public override Maybe liftA2(Function2 mergeFn, Applicative arg2) {
            return (Maybe) arg2.fmap((Function1) mergeFn.apply(value));
        }

        public override Maybe bind(Function1 aToMonadB) {
            return (Maybe)aToMonadB.apply(value);
        }

        public override Object getOrDefault(Object defaultValue) {
            return value;
        }

        public override Object getOrError() {
            return value;
        }

        public override Maybe orElseJust(Object valueInJust) {
            return this;
        }

        public override Maybe filter(Function1 predicate) {
            return ((Boolean)predicate.apply(value))
                    ? this
                    : Nothing;
        }
    }

    public class OfFunction extends Function1{
        OfFunction() {}

        public override Object apply(Object arg) {
            return Maybe.of(arg);
        }
    }

    public class NoSuchElementException extends Exception {}
}