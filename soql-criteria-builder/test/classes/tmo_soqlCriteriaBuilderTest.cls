@isTest(isParallel=true)
private class tmo_soqlCriteriaBuilderTest {
  @isTest
  static void equalsToCriteriaForString() {
    assertEquals('Name = \'salesforce\'', cb().equalsTo(Account.Name, 'salesforce'));
  }

  @isTest
  static void equalsToCriteriaForBoolean() {
    assertEquals('HasOpportunityLineItem = true', cb().equalsTo(Opportunity.HasOpportunityLineItem, true));
  }

  @isTest
  static void equalsToCriteriaForNumeric() {
    assertEquals('TotalOpportunityQuantity = 2', cb().equalsTo(Opportunity.TotalOpportunityQuantity, 2));
  }

  @isTest
  static void notEqualsToCriteriaForString() {
    assertEquals('Name != \'microsoft\'', cb().notEqualsTo(Account.Name, 'microsoft'));
  }

  @isTest
  static void notEqualsToCriteriaForNumeric() {
    assertEquals('TotalOpportunityQuantity != 2', cb().notEqualsTo(Opportunity.TotalOpportunityQuantity, 2));
  }

  @isTest
  static void greaterOrEqualCriteriaForNumeric() {
    assertEquals('TotalOpportunityQuantity >= 2', cb().greaterOrEqual(Opportunity.TotalOpportunityQuantity, 2));
  }

  @isTest
  static void greaterThanCriteriaForNumeric() {
    assertEquals('TotalOpportunityQuantity > 2', cb().greaterThan(Opportunity.TotalOpportunityQuantity, 2));
  }

  @isTest
  static void lessThanCriteriaForNumeric() {
    assertEquals('TotalOpportunityQuantity < 2', cb().lessThan(Opportunity.TotalOpportunityQuantity, 2));
  }

  @isTest
  static void lessOrEqualCriteriaForNumeric() {
    assertEquals('TotalOpportunityQuantity <= 2', cb().lessOrEqual(Opportunity.TotalOpportunityQuantity, 2));
  }

  @isTest
  static void inCriteriaForStrings() {
    List<String> inValues = new List<String>{ 'BMW', 'Jeep' };
    assertEquals('Name IN (\'BMW\',\'Jeep\')', cb().isIn(Account.Name, inValues));
  }

  @isTest
  static void inCriteriaForNonStrings() {
    List<Integer> inValues = new List<Integer>{ 1, 2, 3 };
    assertEquals('NumberOfEmployees IN (1,2,3)', cb().isIn(Account.NumberOfEmployees, inValues));
  }

  @isTest
  static void inCriteriaForSubSelect() {
    String subSelect = 'SELECT Id FROM Account';
    assertEquals('AccountId IN (SELECT Id FROM Account)', cb().isIn(Contact.AccountId, subSelect));
  }

  @isTest
  static void notInCriteriaForSubSelect() {
    String subSelect = 'SELECT Id FROM Account';
    assertEquals('AccountId NOT IN (SELECT Id FROM Account)', cb().isNotIn(Contact.AccountId, subSelect));
  }

  @isTest
  static void notInCriteriaForStrings() {
    List<String> inValues = new List<String>{ 'BMW', 'Jeep' };
    assertEquals('Name NOT IN (\'BMW\',\'Jeep\')', cb().isNotIn(Account.Name, inValues));
  }

  @isTest
  static void notInCriteriaForNonStrings() {
    List<Integer> inValues = new List<Integer>{ 1, 2, 3 };
    assertEquals('NumberOfEmployees NOT IN (1,2,3)', cb().isNotIn(Account.NumberOfEmployees, inValues));
  }

  @isTest
  static void likeCriteria() {
    assertEquals('Name LIKE \'%force\'', cb().isLike(Account.Name, '%force'));
  }

  @isTest
  static void wrapsNotLikeCriteriaIntoBrackets() {
    assertEquals('(NOT Name LIKE \'%force\')', cb().isNotLike(Account.Name, '%force'));
  }

  @isTest
  static void isNull() {
    assertEquals('Name = NULL', cb().isNull(Account.Name));
  }

  @isTest
  static void isNotNull() {
    assertEquals('Name != NULL', cb().isNotNull(Account.Name));
  }

  @isTest
  static void joinsCriteriaViaAndByDefault() {
    assertEquals(
      'Industry != NULL AND NumberOfEmployees >= 100',
      cb().isNotNull(Account.Industry).greaterOrEqual(Account.NumberOfEmployees, 100)
    );
  }

  @isTest
  static void canJoinViaOrIfConfigured() {
    assertEquals(
      'Industry != NULL OR NumberOfEmployees >= 100',
      cb().isNotNull(Account.Industry).withOr().greaterOrEqual(Account.NumberOfEmployees, 100)
    );
  }

  @isTest
  static void criteriaBasedOnReferenceAttributes() {
    assertEquals(
      'Account.Industry != NULL AND Account.NumberOfEmployees >= 100',
      cb()
        .configureForReferenceField(Contact.AccountId)
        .isNotNull(Account.Industry)
        .greaterOrEqual(Account.NumberOfEmployees, 100)
    );
  }

  @isTest
  static void wrapsCompositeCriteriaIntoBrackets() {
    assertEquals(
      'Department LIKE \'Finance%\' AND (Email = NULL OR Title != NULL)',
      cb()
        .isLike(Contact.Department, 'Finance%')
        .composite(cb().isNull(Contact.Email).withOr().isNotNull(Contact.Title))
    );
  }

  @isTest
  static void bindingBuilderUsesBindingVariables() {
    assertEquals('Name = :companyName', bb().equalsTo(Account.Name, ':companyName'));
    assertEquals('Name != :companyName', bb().notEqualsTo(Account.Name, ':companyName'));
    assertEquals('NumberOfEmployees > :value', bb().greaterThan(Account.NumberOfEmployees, ':value'));
    assertEquals('NumberOfEmployees >= :value', bb().greaterOrEqual(Account.NumberOfEmployees, ':value'));
    assertEquals('NumberOfEmployees < :value', bb().lessThan(Account.NumberOfEmployees, ':value'));
    assertEquals('NumberOfEmployees <= :value', bb().lessOrEqual(Account.NumberOfEmployees, ':value'));
    assertEquals('Name = NULL', bb().isNull(Account.Name));
    assertEquals('Name != NULL', bb().isNotNull(Account.Name));
    assertEquals('Name IN :inValues', bb().isIn(Account.Name, ':inValues'));
    assertEquals('Name NOT IN :inValues', bb().isNotIn(Account.Name, ':inValues'));
    assertEquals('Name LIKE :likeValue', bb().isLike(Account.Name, ':likeValue'));
    assertEquals('(NOT Name LIKE :likeValue)', bb().isNotLike(Account.Name, ':likeValue'));
  }

  @isTest
  static void bindingBuilderFailsIfNotWithStringArgument() {
    Integer numberOfMethodsToCheck = 6;
    Integer numberOfMethodsChecked = 0;
    for (Integer i = 0; i < numberOfMethodsToCheck; i++) {
      try {
        switch on i {
          when 0 {
            bb().equalsTo(Account.NumberOfEmployees, 100);
          }
          when 1 {
            bb().notEqualsTo(Account.NumberOfEmployees, 100);
          }
          when 2 {
            bb().greaterThan(Account.NumberOfEmployees, 100);
          }
          when 3 {
            bb().greaterOrEqual(Account.NumberOfEmployees, 100);
          }
          when 4 {
            bb().lessThan(Account.NumberOfEmployees, 100);
          }
          when 5 {
            bb().lessOrEqual(Account.NumberOfEmployees, 100);
          }
          when else {
            System.assert(false, 'uncreachable: expected number of methods to be checked');
          }
        }
      } catch (IllegalArgumentException iae) {
        numberOfMethodsChecked++;
      }
    }
    System.assertEquals(numberOfMethodsToCheck, numberOfMethodsChecked, 'should fail on all non binding methods');
  }

  @isTest
  static void bindingBuilderFailsIfNotWithBindingVariable() {
    Integer numberOfMethodsToCheck = 6;
    Integer numberOfMethodsChecked = 0;
    for (Integer i = 0; i < numberOfMethodsToCheck; i++) {
      try {
        switch on i {
          when 0 {
            bb().equalsTo(Account.Name, 'salesforce');
          }
          when 1 {
            bb().notEqualsTo(Account.Name, 'salesforce');
          }
          when 2 {
            bb().greaterThan(Account.NumberOfEmployees, '100');
          }
          when 3 {
            bb().greaterOrEqual(Account.NumberOfEmployees, '100');
          }
          when 4 {
            bb().lessThan(Account.NumberOfEmployees, '100');
          }
          when 5 {
            bb().lessOrEqual(Account.NumberOfEmployees, '100');
          }
          when else {
            System.assert(false, 'uncreachable: expected number of methods to be checked');
          }
        }
      } catch (IllegalArgumentException iae) {
        numberOfMethodsChecked++;
      }
    }
    System.assertEquals(numberOfMethodsToCheck, numberOfMethodsChecked, 'should fail on all non binding methods');
  }

  private static tmo_soqlCriteriaBuilder cb() {
    return tmo_soqlCriteriaBuilder.stringCriteriaBuilder();
  }

  private static tmo_soqlCriteriaBuilder bb() {
    return tmo_soqlCriteriaBuilder.bindingBuilder();
  }

  private static void assertEquals(String expectedCriteria, tmo_soqlCriteriaBuilder criteriaBuilder) {
    System.assertEquals(expectedCriteria, criteriaBuilder.toCriteria());
  }
}
