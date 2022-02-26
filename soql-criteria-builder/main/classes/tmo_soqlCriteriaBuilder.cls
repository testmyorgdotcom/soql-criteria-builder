public inherited sharing virtual class tmo_soqlCriteriaBuilder {
  private String referenceFieldNamePreffix;
  private List<String> criteria;
  private List<Boolean> trueIfAndJoinElements;
  private Boolean nextJoinFlagValue;

  private tmo_soqlCriteriaBuilder() {
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

  public virtual tmo_soqlCriteriaBuilder equalsTo(Schema.SObjectField field, Object fieldValue) {
    addCriteria(fieldName(field) + ' = ' + fieldValue(field, fieldValue));
    return this;
  }

  private String fieldName(Schema.SObjectField field) {
    String fieldName = field.getDescribe().getName();
    return referenceFieldNamePreffix != null ? referenceFieldNamePreffix + fieldName : fieldName;
  }

  private String fieldValue(Schema.SObjectField field, Object fieldValue) {
    String value = null;
    if (Schema.DisplayType.DATE.equals(field.getDescribe().getType())) {
      value = formatDate(fieldValue);
    } else {
      value = wrapIntoQuotesIfString(fieldValue);
    }
    return value;
  }

  private String formatDate(Object dateOrString) {
    if (dateOrString instanceof String) {
      return '' + dateOrString;
    } else {
      Date dateValue = (Date) dateOrString;
      List<String> dateParts = new List<String>{
        withLeadingZero(dateValue.year()),
        withLeadingZero(dateValue.month()),
        withLeadingZero(dateValue.day())
      };
      return String.join(dateParts, '-');
    }
  }

  private String withLeadingZero(Integer oneTwoDigits) {
    return oneTwoDigits > 9 ? '' + oneTwoDigits : '0' + oneTwoDigits;
  }

  private String wrapIntoQuotesIfString(Object value) {
    if (value instanceof String) {
      return '\'' + value + '\'';
    }
    return '' + value;
  }

  public virtual tmo_soqlCriteriaBuilder notEqualsTo(Schema.SObjectField field, Object fieldValue) {
    addCriteria(fieldName(field) + ' != ' + fieldValue(field, fieldValue));
    return this;
  }

  public virtual tmo_soqlCriteriaBuilder greaterOrEqual(Schema.SObjectField field, Object fieldValue) {
    addCriteria(fieldName(field) + ' >= ' + fieldValue(field, fieldValue));
    return this;
  }

  public virtual tmo_soqlCriteriaBuilder greaterThan(Schema.SObjectField field, Object fieldValue) {
    addCriteria(fieldName(field) + ' > ' + fieldValue(field, fieldValue));
    return this;
  }

  public virtual tmo_soqlCriteriaBuilder lessThan(Schema.SObjectField field, Object fieldValue) {
    addCriteria(fieldName(field) + ' < ' + fieldValue(field, fieldValue));
    return this;
  }

  public virtual tmo_soqlCriteriaBuilder lessOrEqual(Schema.SObjectField field, Object fieldValue) {
    addCriteria(fieldName(field) + ' <= ' + fieldValue(field, fieldValue));
    return this;
  }

  public virtual tmo_soqlCriteriaBuilder isIn(Schema.SObjectField field, List<Object> inValues) {
    addCriteria(fieldName(field) + ' IN ' + wrapIntoBrackets(convertToInValuesAsString(inValues)));
    return this;
  }

  public virtual tmo_soqlCriteriaBuilder isIn(Schema.SObjectField field, String subSelect) {
    addCriteria(fieldName(field) + ' IN ' + wrapIntoBrackets(subSelect));
    return this;
  }

  public virtual tmo_soqlCriteriaBuilder isNotIn(Schema.SObjectField field, List<Object> inValues) {
    addCriteria(fieldName(field) + ' NOT IN ' + wrapIntoBrackets(convertToInValuesAsString(inValues)));
    return this;
  }

  public virtual tmo_soqlCriteriaBuilder isNotIn(Schema.SObjectField field, String subSelect) {
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

  public virtual tmo_soqlCriteriaBuilder isLike(Schema.SObjectField field, String fieldValue) {
    addCriteria(fieldName(field) + ' LIKE ' + wrapIntoQuotesIfString(fieldValue));
    return this;
  }

  public virtual tmo_soqlCriteriaBuilder isNotLike(Schema.SObjectField field, String fieldValue) {
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

  public static tmo_soqlCriteriaBuilder stringCriteriaBuilder() {
    return new tmo_soqlCriteriaBuilder();
  }

  public static tmo_soqlCriteriaBuilder bindingBuilder() {
    return new tmo_bindingSoqlCriteriaBuilder();
  }

  private inherited sharing class tmo_bindingSoqlCriteriaBuilder extends tmo_soqlCriteriaBuilder {
    public override tmo_soqlCriteriaBuilder equalsTo(Schema.SObjectField field, Object fieldValue) {
      failIfNotBindingVariable(fieldValue);
      addCriteria(fieldName(field) + ' = ' + fieldValue);
      return this;
    }

    private void failIfNotBindingVariable(Object fieldValue) {
      if (!(fieldValue instanceof String) || !fieldValue?.toString().startsWith(':')) {
        throw new IllegalArgumentException('binding builder can work with Binding Variables only');
      }
    }

    public override tmo_soqlCriteriaBuilder notEqualsTo(Schema.SObjectField field, Object fieldValue) {
      failIfNotBindingVariable(fieldValue);
      addCriteria(fieldName(field) + ' != ' + fieldValue);
      return this;
    }

    public override tmo_soqlCriteriaBuilder greaterOrEqual(Schema.SObjectField field, Object fieldValue) {
      failIfNotBindingVariable(fieldValue);
      addCriteria(fieldName(field) + ' >= ' + fieldValue);
      return this;
    }

    public override tmo_soqlCriteriaBuilder greaterThan(Schema.SObjectField field, Object fieldValue) {
      failIfNotBindingVariable(fieldValue);
      addCriteria(fieldName(field) + ' > ' + fieldValue);
      return this;
    }

    public override tmo_soqlCriteriaBuilder lessThan(Schema.SObjectField field, Object fieldValue) {
      failIfNotBindingVariable(fieldValue);
      addCriteria(fieldName(field) + ' < ' + fieldValue);
      return this;
    }

    public override tmo_soqlCriteriaBuilder lessOrEqual(Schema.SObjectField field, Object fieldValue) {
      failIfNotBindingVariable(fieldValue);
      addCriteria(fieldName(field) + ' <= ' + fieldValue);
      return this;
    }

    public override tmo_soqlCriteriaBuilder isIn(Schema.SObjectField field, String fieldValue) {
      addCriteria(fieldName(field) + ' IN ' + fieldValue);
      return this;
    }

    public override tmo_soqlCriteriaBuilder isIn(Schema.SObjectField field, List<Object> fieldValue) {
      failIfNotBindingVariable(fieldValue);
      return this;
    }

    public override tmo_soqlCriteriaBuilder isNotIn(Schema.SObjectField field, String fieldValue) {
      addCriteria(fieldName(field) + ' NOT IN ' + fieldValue);
      return this;
    }

    public override tmo_soqlCriteriaBuilder isNotIn(Schema.SObjectField field, List<Object> fieldValue) {
      failIfNotBindingVariable(fieldValue);
      return this;
    }

    public override tmo_soqlCriteriaBuilder isLike(Schema.SObjectField field, String fieldValue) {
      addCriteria(fieldName(field) + ' LIKE ' + fieldValue);
      return this;
    }

    public override tmo_soqlCriteriaBuilder isNotLike(Schema.SObjectField field, String fieldValue) {
      addCriteria(wrapIntoBrackets('NOT ' + fieldName(field) + ' LIKE ' + fieldValue));
      return this;
    }
  }
}
