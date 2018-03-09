// ===============================================================
// チェックボックスをクリックすると、valueとdata属性が表示される
// 
// 関数を定義した上で、htmlの中でonclickを記述し、クリックイベントを発動させる。
// 
// htmlにdata属性をもたせ、
// getattributeとsetattributeでhtmlとjavascriptで値をやりとりする
//   element.onclick = 関数名;
//   とすると、onclickが実行されてしまうため
// ===============================================================
function boxCheck(){
  let str = "";
  // ボタンをクリックしてから関数が実行されるため、ローカル変数でも大丈夫
  let p = 0;
  
  for(let i=0; i<5; i++){
    // formではname属性を指定する
    // elements[]でチェックボックスを配列として扱える
    let el = document.checkbox.elements[i];
    
    // 各チェックボックスがチェックされた場合
    if(el.checked){
      str += el.value;
      // data属性は文字列のため、parseFloatで数値に変換する
      // data属性を取得するには、geteAttributeを使う
      p += parseFloat(el.getAttribute("data-p"));
    }
  }
  
  // 表示する
  alert(str + "が選択されたよ" + p);
}


// ===============================================================
// チェックボックスをクリックすると、
// 
// 関数を定義した上で、htmlの中でonchangeを記述し、変更があれば関数を実行する
//   onchangeは、input、select、textareaしか使えないことに注意
// 
// htmlにdata属性をもたせ、
// getattributeとsetattributeでhtmlとjavascriptで値をやりとりする
// ===============================================================
function realtimeCheck(obj){
  let p = 0;
  
  // 各チェックボックスがチェックされた場合
  if(obj.checked){
    // data属性は文字列のため、parseFloatで数値に変換する
    // data属性を取得するには、geteAttributeを使う
    p += parseFloat(obj.getAttribute("data-p"));
  }

  // 表示する
  let table_p = document.getElementById("table-p");
  table_p.innerHTML = p;
}



// ===============================================================
// チェックボックスをクリックすると、動的にhtmlを書き換える
// 
// 上記2つの関数をまとめたもの
// 
// 関数を定義した上で、htmlの中でonchangeを記述し、変更があれば関数を実行する
//   onchangeは、input、select、textareaしか使えないことに注意
// <form>の中のチェックボックスをつけた<input>の全てに、「onchange=realtimeCheck02()」とする
// 
// htmlにdata属性をもたせ、
// getattributeとsetattributeでhtmlとjavascriptで値をやりとりする
// ===============================================================
function realtimeCheck02(){
  // p,f,cの値を初期化
  let p = 0;
  let f = 0;
  let c = 0;
  // チェックボックスの数
  let len = document.checkbox.elements.length;
  
  for(let i=0; i<len; i++){
    // formではname属性を指定する
    // elements[]でチェックボックスを配列として扱える
    let el = document.checkbox.elements[i];
    
    // 各チェックボックスがチェックされた場合
    if(el.checked){
      // data属性は文字列のため、parseFloatで数値に変換する
      // data属性を取得するには、geteAttributeを使う
      p += parseFloat(el.getAttribute("data-p"));
      f += parseFloat(el.getAttribute("data-f"));
      c += parseFloat(el.getAttribute("data-c"));
    }
  }

  // <table><tr><td id="table-*">以下を数値で書き換える
  let table_p = document.getElementById("table-p");
  let table_f = document.getElementById("table-f");
  let table_c = document.getElementById("table-c");
  // table_p.innerHTML = p;
  table_p.textContent = p;
  table_f.textContent = f;
  table_c.textContent = c;
}


function realtimeCheck03(){
  // p,f,cの値を初期化
  let p = 0;
  let f = 0;
  let c = 0;
  // チェックボックスの数
  let len = document.checkbox2.elements.length;
  
  for(let i=0; i<len; i++){
    // formではname属性を指定する
    // elements[]でチェックボックスを配列として扱える
    let el = document.checkbox2.elements[i];
    
    // 各チェックボックスがチェックされた場合
    if(el.checked){
      // data属性は文字列のため、parseFloatで数値に変換する
      // data属性を取得するには、geteAttributeを使う
      p += parseFloat(el.getAttribute("data-p"));
      f += parseFloat(el.getAttribute("data-f"));
      c += parseFloat(el.getAttribute("data-c"));
    }
  }

  // <table><tr><td id="table-*">以下を数値で書き換える
  let table_p = document.getElementById("table-p");
  let table_f = document.getElementById("table-f");
  let table_c = document.getElementById("table-c");
  // table_p.innerHTML = p;
  table_p.textContent = p;
  table_f.textContent = f;
  table_c.textContent = c;
}


// ===============================================================
// アコーディオンパネル
// 
// ===============================================================
// turbolinksが原因で、ページ遷移時、jqueryが動かなかったため、対策
$(document).on ('turbolinks:load', function(){
// $(document).ready(function() {

  $('.acBody').each(function(){
      $(this).css("height",$(this).height()+"px");
  });
  
  $('.acBody').hide();
  
  $('.acHead').click(function () {
      // $(this).next('.acBody').slideToggle("fast");
      $(this).next().slideToggle('fast');
      $(this).toggleClass('active');
  });
  
  
});

// ===============================================================
// 固定ヘッダーの高さ分、bodyをずらす
// 
// ===============================================================
// $(window).on('load resize', function(){
//     // navbarの高さを取得する
//     var height = $('.navbar').height();
//     // bodyのpaddingにnavbarの高さを設定する
//     $('body').css('padding-top',height); 
// });

// ===============================================================
// ajaxでセレクトタブを動的に変更する
// 複数のセレクトタブでは対応できないため、一度停止
// ===============================================================
// $(document).on('turbolinks:load', function(){
//   $("#ingredient_category1").change(function(){
//     $.get({
//       url: "/select",
//       data: {ingredient_category1: $("#ingredient_category1").has("option:selected").val()}
//     });
//   });
  
//   $("#ingredient_category2").change(function(){
//   $.get({
//     url: "/select",
//     data: {ingredient_category2: $("#ingredient_category2").has("option:selected").val()}
//   });
// });

// });
