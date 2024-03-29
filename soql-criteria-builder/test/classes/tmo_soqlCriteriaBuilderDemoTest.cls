@isTest(isParallel=true)
private class tmo_soqlCriteriaBuilderDemoTest {
  @isTest
  static void simpleCriteria() {
    String simpleCriteria = 'AccountId != NULL AND (NOT LastName LIKE \'A%\') AND Department = \'Finance\'';
    tmo_soqlCriteriaBuilder cb = cb()
      .isNotNull(Contact.AccountId)
      .isNotLike(Contact.LastName, 'A%')
      .equalsTo(Contact.Department, 'Finance');

    System.assertEquals(simpleCriteria, cb.toCriteria());
  }

  @isTest
  static void betweenCriteria() {
    String betweenCriteria = 'NumberOfEmployees > 1000 AND NumberOfEmployees < 2000';
    tmo_soqlCriteriaBuilder cb = cb()
      .greaterThan(Account.NumberOfEmployees, 1000)
      .lessThan(Account.NumberOfEmployees, 2000);

    System.assertEquals(betweenCriteria, cb.toCriteria());
  }

  @isTest
  static void conditionalQueryBuilder() {
    String complexCriteria =
      'IsWon = true AND Amount > 100000 AND' +
      ' ((Account.NumberOfEmployees > 1000 AND Account.BillingCountry = \'USA\') OR (Owner.Title = \'CEO\' AND Owner.Country = \'USA\'))';
    tmo_soqlCriteriaBuilder bigUsCompanies = cb()
      .configureForReferenceField(Opportunity.AccountId)
      .greaterThan(Account.NumberOfEmployees, 1000)
      .equalsTo(Account.BillingCountry, 'USA');

    tmo_soqlCriteriaBuilder ownerInUs = cb()
      .configureForReferenceField(Opportunity.OwnerId)
      .equalsTo(User.Title, 'CEO')
      .equalsTo(User.Country, 'USA');

    tmo_soqlCriteriaBuilder cb = cb()
      .equalsTo(Opportunity.IsWon, true)
      .greaterThan(Opportunity.Amount, 100000)
      .composite(cb().composite(bigUsCompanies).withOr().composite(ownerInUs));

    System.assertEquals(complexCriteria, cb.toCriteria());
  }

  private static tmo_soqlCriteriaBuilder cb() {
    return tmo_soqlCriteriaBuilder.builder();
  }
}
