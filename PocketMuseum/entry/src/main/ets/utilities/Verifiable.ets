import Result from "./Result";

export default interface Verifable<T = null> {
  verify() : Result<T>;
}
