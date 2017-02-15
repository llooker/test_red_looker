view: users {
  sql_table_name: public.users ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: age {
    type: number
    sql: ${TABLE}.age ;;
  }

  dimension: age_tier {
    type: tier
    tiers: [0,10,20,30,40,60,80,100]
    sql: ${age} ;;
  }

  dimension: is_over_21 {
    hidden: yes
    type: yesno
    sql:  ${age}>=21 ;;
  }

dimension: city_state {
  sql: ${city}||' ' ||${state} ;;
}

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: country {
    type: string
    sql: UPPER(${TABLE}.country) ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension: email {
    label: "e-mail"
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: first_name {
    hidden: yes
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: last_name {
    hidden: yes
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: name {
    label: "Full Name"
    description: "Full Name of the User"
    type: string
    sql:  ${first_name} || ' ' || ${last_name} ;;
  }


  dimension: gender {
    type: string
    sql: CASE
          WHEN ${TABLE}.gender = 'f'
            THEN 'Female'
          ELSE 'Male'
        END ;;
  }



  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
    drill_fields: [city]
    link: {
      label: " explore by city"
      url: "https://teach.corp.looker.com/explore/test_look/users?fields=users.gender,users.average_age,users.count,users.city&f[users.gender]=Male&f[users.state]={{ value }}"
    }
  }

  dimension: traffic_source {
    type: string
    sql: ${TABLE}.traffic_source ;;
  }

  dimension: zip {
    type: zipcode
    sql: ${TABLE}.zip ;;

  }

  measure: count {
    type: count
    drill_fields: [user_drill*, orders.count]
  }




  measure: average_age {
    type: average
    sql: ${age} ;;
    drill_fields: [user_drill*, age, orders.count]
  }

  measure: average_age_over_21 {
    type: average
    sql: ${age} ;;
    drill_fields: [user_drill*, age, orders.count]
    filters: {
      field: is_over_21
      value: "yes"
    }
  }

  set: user_drill {
    fields: [id, first_name, last_name,zip]
  }






}
