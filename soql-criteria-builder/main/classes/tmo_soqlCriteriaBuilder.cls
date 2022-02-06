public inherited sharing class tmo_soqlCriteriaBuilder {
  private String referenceFieldNamePreffix;
  private List<String> criteria;
  private List<Boolean> trueIfAndJoinElements;
  private Boolean nextJoinFlagValue;

  public tmo_soqlCriteriaBuilder() {
    referenceFieldNamePreffix = null;
    criteria = new List<String>();
    trueIfAndJoinElements = new List<Boolean>();
    nextJoinFlagValue = true;
  }

  public tmo_soqlCriteriaBuilder withOr() {
    nextJoinFlagValue = false;
    return this;
  }

  public tmo_soqlCriteriaBuilder withAnd() {
    nextJoinFlagValue = true;
    return this;
  }

  public String toCriteria() {
    List<String> finalCriteriaElements = new List<String>();
    Iterator<String> criteriaIterator = criteria.iterator();
    Iterator<Boolean> joinIterator = trueIfAndJoinElements.iterator();
    while (criteriaIterator.hasNext()) {
      finalCriteriaElements.add(criteriaIterator.next());
      if (joinIterator.hasNext()) {
        finalCriteriaElements.add(joinIterator.next() ? 'AND' : 'OR');
      }
    }
    return String.join(finalCriteriaElements, ' ');
  }

  public tmo_soqlCriteriaBuilder configureForReferenceField(Schema.SObjectField referenceField) {
    referenceFieldNamePreffix = referenceField.getDescribe().getRelationshipName() + '.';
    return this;
  }

  public tmo_soqlCriteriaBuilder equalsTo(Schema.SObjectField field, Object fieldValue) {
    addCriteria(fieldName(field) + ' = ' + wrapIntoQuotesIfString(fieldValue));
    return this;
  }

  private String fieldName(Schema.SObjectField field) {
    String fieldName = field.getDescribe().getName();
    return referenceFieldNamePreffix != null ? referenceFieldNamePreffix + fieldName : fieldName;
  }

  private String wrapIntoQuotesIfString(Object value) {
    if (value instanceof String) {
      return '\'' + value + '\'';
    }
    return '' + value;
  }

  public tmo_soqlCriteriaBuilder greaterOrEqual(Schema.SObjectField field, Object fieldValue) {
    addCriteria(fieldName(field) + ' >= ' + fieldValue);
    return this;
  }

  public tmo_soqlCriteriaBuilder greaterThan(Schema.SObjectField field, Object fieldValue) {
    addCriteria(fieldName(field) + ' > ' + fieldValue);
    return this;
  }

  public tmo_soqlCriteriaBuilder lessThan(Schema.SObjectField field, Object fieldValue) {
    addCriteria(fieldName(field) + ' < ' + fieldValue);
    return this;
  }

  public tmo_soqlCriteriaBuilder lessOrEqual(Schema.SObjectField field, Object fieldValue) {
    addCriteria(fieldName(field) + ' <= ' + fieldValue);
    return this;
  }

  public tmo_soqlCriteriaBuilder isIn(Schema.SObjectField field, List<Object> inValues) {
    addCriteria(fieldName(field) + ' IN ' + wrapIntoBrackets(convertToInValuesAsString(inValues)));
    return this;
  }

  public tmo_soqlCriteriaBuilder isIn(Schema.SObjectField field, String subSelect) {
    addCriteria(fieldName(field) + ' IN ' + wrapIntoBrackets(subSelect));
    return this;
  }

  public tmo_soqlCriteriaBuilder isNotIn(Schema.SObjectField field, List<Object> inValues) {
    addCriteria(fieldName(field) + ' NOT IN ' + wrapIntoBrackets(convertToInValuesAsString(inValues)));
    return this;
  }

  public tmo_soqlCriteriaBuilder isNotIn(Schema.SObjectField field, String subSelect) {
    addCriteria(fieldName(field) + ' NOT IN ' + wrapIntoBrackets(subSelect));
    return this;
  }

  private String wrapIntoBrackets(String value) {
    return '(' + value + ')';
  }

  private String convertToInValuesAsString(List<Object> inValues) {
    if (inValues instanceof List<String>) {
      return convertToInString(inValues);
    }
    return String.join(inValues, ',');
  }

  private String convertToInString(List<Object> inValues) {
    return wrapIntoQuotesIfString(String.join(inValues, '\',\''));
  }

  public tmo_soqlCriteriaBuilder composite(tmo_soqlCriteriaBuilder complexCriteria) {
    addCriteria(wrapIntoBrackets(complexCriteria.toCriteria()));
    return this;
  }

  public tmo_soqlCriteriaBuilder notEqualsTo(Schema.SObjectField field, Object fieldValue) {
    addCriteria(fieldName(field) + ' != ' + wrapIntoQuotesIfString(fieldValue));
    return this;
  }
  public tmo_soqlCriteriaBuilder isLike(Schema.SObjectField field, Object fieldValue) {
    addCriteria(fieldName(field) + ' LIKE ' + wrapIntoQuotesIfString(fieldValue));
    return this;
  }

  public tmo_soqlCriteriaBuilder isNotLike(Schema.SObjectField field, Object fieldValue) {
    String singleCriteria = 'NOT ' + fieldName(field) + ' LIKE ' + wrapIntoQuotesIfString(fieldValue);
    addCriteria(wrapIntoBrackets(singleCriteria));
    return this;
  }

  public tmo_soqlCriteriaBuilder isNull(Schema.SObjectField field) {
    addCriteria(fieldName(field) + ' = NULL');
    return this;
  }

  public tmo_soqlCriteriaBuilder isNotNull(Schema.SObjectField field) {
    addCriteria(fieldName(field) + ' != NULL');
    return this;
  }

  private void addCriteria(String criterion) {
    if (!criteria.isEmpty()) {
      trueIfAndJoinElements.add(nextJoinFlagValue);
      withAnd();
    }
    criteria.add(criterion);
  }
}
