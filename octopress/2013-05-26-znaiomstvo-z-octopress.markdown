---
layout: post
title: "Знайомство з Octopress"
date: 2013-05-26 11:40
comments: true
categories: octopress
---


[Octopress](http://octopress.org) - технологія, яка дозволяє зручно генерувати статичний контент в HTML вигляді.
Я спочатку пишу пост, редагую шаблон, виправляю якийсь код, але зміни застосовуються до сайту тільки після запуску команди генерації. Мінус в тому, що якщо сайт занадто великий, то процес генерації буде йти довго. Мій блог досить маленький, на його генерацію потрібно декілька секунд. 

<!-- more --> 

Що ж в ньому такого особливого? Оновлювати по суті нічого, крім елементів движка (на відміну від Wordpress). Конфігураційних файлів мало і в них легко розібратися. Немає MySQL, немає PHP, немає Apache. Динамічний контент додається за допомогою javascript плагінів. У моєму випадку це Twitter стрічка в сайдбарі і система коментування Disqus. Тема оформлення мінімалістична, читати статті одне задоволення. Вона вміє автоматично масштабуватися в залежності від ширини браузера. Спробуйте звузити його або зайти з iPhone. Сайдбар тут же піде вниз, а шрифт поміняє розміри на більш комфортні. Відпадає потреба в оптимізації під всі мобільні девайси. Статті тепер можна писати в будь-якому текстовому редакторі, тепер це особливо зручно за допомогою технології markdown. 
**************
Щоб встановити Octopress, потрібно:






###Крок 1: Встановити Git, RVM and Ruby


[Тут](http://www.moncefbelyamani.com/how-to-install-xcode-homebrew-git-rvm-ruby-on-mac/) все гарно розписано.

###Крок 2: Створити репозиторій на GitHub
Зареєструватися на [GitHub](http://github.com) і створити репозиторій з назвою `octopress` (або іншою). В результаті маємо http://github.com/YourName/octopress

<!-- more --> 

###Крок 3: Встановити Octopress

 В терміналі ввести наступні команди:
 

	mkdir octopress
	cd octopress
	git	 init
	git	 remote add octopress git://github.com/imathis/octopress.git
	git pull octopress master
	git checkout -b source
	git remote add origin git@github.com:YourName/octopress.git
	git push origin source

	rvm rvmrc trust
	rvm reload
	rake setup_github_pages
	git@github.com:YourName/octopress.git
	rake install
 
 дописати в файлі `_config.yml` root: /octopress
 
	rake generate
	rake deploy
В результаті маємо наш блог: `http://YourName.github.com/octopress`

#####Скрінкаст

<iframe width="750" height="563" src="http://www.youtube.com/embed/Hcj-GhNm-Ik?rel=0" frameborder="0" allowfullscreen></iframe>
###Крок 4: Налаштувати Octopress

Редактувати файл `_config.yml`,
щоб URL були короткими і няшними:

	permalink: /:title/
	category_dir: categories
	pagination_dir:  #empty

Для додавання категорій в сайдбарі: створити файл
`source/_includes/custom/asides/links.html` в якому щось типу:

```
<section>
  <h1>Закладки</h1>
  <ul>
      <li><a href="http://google.com">Google</a></li>
      <li><a href="http://pikabu.ru">Пікабу</a></li>
  </ul>
</section>
```
і в файлі `_config.yml` добавити в кінці посилання на сторінку:
	
	default_asides: [asides/recent_posts.html, asides/github.html, asides/delicious.html, asides/pinboard.html, asides/googleplus.html, custom/asides/links.html]
	
Для того щоб замість `http://yoursite.com/blog/archives`  було `http://yoursite.com/archives` , потрібно `source/blog/archives` перенести в `source`, і в пошуку замінити кожне `/blog/archives` на `/archives`



###Крок 5: Оформлення Octopress

[Тут](http://www.evolument.com/blog/2013/03/02/top-10-plus-octopress-themes/) є декілька няшних тем, але можна й самому змінювати все.


Для зміни вкладок навігаційного меню: `source/_includes/custom/navigation.html`


Для зміни фонового зображення: 75 рядок в `sass/base/_theme.css`.
Популярні зображення [тут](http://subtlepatterns.com)


Для зміни будь-яких кольорів: `sass/custom/_colors.scss`

###Крок 6: Налаштування коментарів

Для створення коментрарів `Disqus` потрібно в адмінці [disqus.com](https://disqus.com/admin) створити сайт, де в налаштуваннях вказати посилання `http://YourName.github.com`. Отриманий `shortname` прописати в `_config.yml`:

	disqus_short_name: someShortName

###Крок 7: Написання статтей

Для створення статті: `rake new_post["title"]`.
Вона з'являється в `source/_posts` з форматом `.markdown`, який редактується програмою [Mou](http://mouapp.com/), досить зручно!

Для того, щоб зміни вступили в силу 
 
	rake generate
	rake deploy
	
або однією командою

	rake gen_deploy	

Для більш детальної інформацію читати [документацію](http://octopress.org/docs/).


###Крок 8: Підтримка Emoticons
Для підключення Emoji потрібно: додати [emoji.rb](https://github.com/chriskempson/jekyll-emoji) в папку `plugins`, додати `emoji_dir: ../images/emoji` в `_config.yml`, `gem 'gemoji'` в `Gemfile`, прописати в терміналі `bundle install`, змінити  `{ { content } }` на `{ { content | emojify } }`(без пробілів між `{``{`) в файлих `article.html` і `page.html`, додати в `_styles.scss`:
{% codeblock lang:css+ruby %}
// Reset image styles for Emoji
.emoji {
  box-shadow: none;
  border: 0;
  height: 20px;
}
{% endcodeblock %}
і скопіювати в папку `source/images/emoji` картинки Emoji, я їх брав (звітси)[https://github.com/arvida/emoji-cheat-sheet.com/tree/master/public/graphics].

Вуаля, готово :smile::+1::v: 
###Крок 9: Блоки коду
Ось [тут](http://octopress.org/docs/plugins/codeblock/) описано як їх зручно використовувати.  
Emoji можна брати звітси: [http://www.emoji-cheat-sheet.com/](http://www.emoji-cheat-sheet.com/).
