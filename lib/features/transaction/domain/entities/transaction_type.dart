/// Transaction type enumeration in the domain layer
/// This ensures Clean Architecture compliance by keeping domain logic separate from data models
enum TransactionType {
  income,
  expense,
  transfer,
}
