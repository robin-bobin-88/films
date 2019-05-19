import Vue from 'vue'
import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';
import locale from 'element-ui/lib/locale/lang/ru-RU'
import axios from 'axios'
import VueAxios from 'vue-axios'
import AppComponent from './AppComponent.vue'

Vue.use(ElementUI, { locale })
Vue.use(VueAxios, axios)

new Vue({
    el: '#app',

    components: {
        AppComponent
    }
})