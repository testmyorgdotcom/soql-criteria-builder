public class tmo_soqlDateFunction {
  public Schema.SObjectField field { get; set; }
  public DateFunction dateFunction;
  public static tmo_soqlDateFunction dateFunction(DateFunction df, Schema.SObjectField field) {
    tmo_soqlDateFunction result = new tmo_soqlDateFunction();
    result.field = field;
    result.dateFunction = df;
    return result;
  }
  public enum DateFunction {
    CALENDAR_MONTH,
    CALENDAR_QUARTER,
    CALENDAR_YEAR,
    DAY_IN_MONTH,
    DAY_IN_WEEK,
    DAY_IN_YEAR,
    DAY_ONLY,
    FISCAL_MONTH,
    FISCAL_QUARTER,
    FISCAL_YEAR,
    HOUR_IN_DAY,
    WEEK_IN_MONTH,
    WEEK_IN_YEAR
  }
}
