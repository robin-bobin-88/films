<template>
    <div>
        <el-row v-if="!EditMode">
            <el-button v-on:click="FilmShowAdd">
                <i class="el-icon-circle-plus-outline el-icon--left"></i>Добавить
            </el-button>
            <el-button :disabled="CurrentFilm == null || FilmCount == 0" v-on:click="FilmShowEdit">
                <i class="el-icon-edit el-icon--left"></i>Редактировать
            </el-button>
            <el-button :disabled="CurrentFilm == null || FilmCount == 0" v-on:click="FilmDelete">
                <i class="el-icon-delete el-icon--left"></i>Удалить
            </el-button>
            <el-button v-on:click="FilmRefresh">
                <i class="el-icon-refresh el-icon--left"></i>Обновить
            </el-button>
        </el-row>

        <film-list-component :Films="Films"
                             :PageSize="PageSize"
                             :FilmCount="FilmCount"
                             :CurrentPage="CurrentPage"
                             :Show="!EditMode"
                             @film-list-current-change="FilmListCurrentChange"
                             @page-current-change="PageCurrentChange">
        </film-list-component>
        
        <film-edit-component :Film="CurrentFilmEdit"
                             :Countries="Countries"
                             :Directors="Directors"
                             :Actors="Actors"
                             :Ganres="Ganres"
                             :Show="EditMode"
                             @film-edit-save="FilmEditSave"
                             @film-edit-cancel="FilmEditCancel">
        </film-edit-component>
    </div>
</template>

<script>
    import FilmListComponent from './FilmListComponent.vue'
    import FilmEditComponent from './FilmEditComponent.vue'

    export default {
        data() {
            return {                
                Countries: null,
                Directors: null,
                Actors: null,
                Ganres: null,

                Films: null,
                CurrentPage: 1,
                PageSize: 5,
                FilmCount: 0,

                CurrentFilm: null,
                CurrentFilmEdit: null,
                
                EditMode: false         
            }
        },

        mounted: function () {
            this.CountriesInit();
            this.DirectorsInit();
            this.ActorsInit();
            this.GanresInit();

            this.FilmRefresh();
        },

        methods: {            
            FilmsInit(page, size) {
                page = page != undefined ? page : null;
                size = size != undefined ? size : null;                

                var app = this;
                app.axios.get(`/api/films/list?page=${page}&size=${size}`)
                    .then(function (response) {
                        app.Films = response.data;
                        app.CurrentFilm = null;
                        app.CurrentFilmEdit = null;
                    })
                    .catch(function (error) {
                        app.Films = null;
                        app.CurrentFilm = null;
                        app.CurrentFilmEdit = null;
                        console.log(error);
                    });
            },

            FilmRefresh() {
                this.FilmsCount();
                this.CurrentPage = 1;
                this.FilmsInit(this.CurrentPage, this.PageSize);
            },

            FilmShowAdd() {
                this.CurrentFilmEdit = { FilmId: 0 };
                this.GanresTypeInit();
                this.EditMode = true;
            },

            FilmShowEdit() {
                this.EditMode = true;
            },

            FilmSave(film) {
                var app = this;
                app.axios({
                        method: film.FilmId == 0 ? 'POST' : 'PUT',
                        url: film.FilmId == 0 ? '/api/films/add' : '/api/films/edit',
                        data: film
                    })
                    .then(function (response) {
                        app.FilmRefresh();
                        app.$message({ type: 'success', message: 'Сохранение завершено' });
                    })
                    .catch(function (error) {
                        console.log(error);
                        app.$message.error(`При сохранении произошла ошибка: ${error}`);
                    });
            },

            FilmDelete() {
                var app = this;
                app.$confirm('Удалить выбранный фильм?', 'Внимание', {
                    confirmButtonText: 'OK',
                    cancelButtonText: 'Отмена',
                    type: 'warning'
                }).then(() => {
                    app.axios.delete(`/api/films/delete/${app.CurrentFilm.FilmId}`)
                        .then(function (response) {
                            app.FilmRefresh();                           
                            app.$message({ type: 'success', message: 'Удаление завершено' });
                        })
                        .catch(function (error) {
                            console.log(error);
                            app.$message.error(`При удалении произошла ошибка: ${error}`);
                        });
                }).catch(() => {                    
                    app.$message({ type: 'info', message: 'Удаление отменено' });
                });
            },

            //-----------------------------------------------------------------------------
            FilmsCount() {
                var app = this;
                app.axios.get(`/api/films/count`)
                    .then(function (response) {
                        app.FilmCount = response.data;
                    })
                    .catch(function (error) {
                        console.log(error);
                    });                
            },

            CountriesInit() {
                var app = this;
                app.axios.get(`/api/films/countries`)
                    .then(function (response) {
                        app.Countries = response.data;
                    })
                    .catch(function (error) {
                        app.Countries = null;
                        console.log(error);
                    });                
            },

            DirectorsInit() {
                var app = this;
                app.axios.get(`/api/films/directors`)
                    .then(function (response) {
                        app.Directors = response.data;
                    })
                    .catch(function (error) {
                        app.Directors = null;
                        console.log(error);
                    });
            },

            ActorsInit() {
                var app = this;
                app.axios.get(`/api/films/actors`)
                    .then(function (response) {
                        app.Actors = response.data;
                    })
                    .catch(function (error) {
                        app.Actors = null;
                        console.log(error);
                    });
            },

            GanresInit() {
                var app = this;
                app.axios.get(`/api/films/ganres`)
                    .then(function (response) {
                        app.Ganres = response.data;
                    })
                    .catch(function (error) {
                        app.Ganres = null;
                        console.log(error);
                    });
            },

            GanresTypeInit() {                
                for (let j = 0; j < this.Ganres.length; j++) {
                    this.Ganres[j].Type = "danger";
                }

                if (this.CurrentFilmEdit != null && this.CurrentFilmEdit.GanreList != null) {
                    for (let i = 0; i < this.CurrentFilmEdit.GanreList.length; i++) {
                        let id = this.CurrentFilmEdit.GanreList[i].GanreId;

                        for (let j = 0; j < this.Ganres.length; j++) {
                            if (this.Ganres[j].GanreId == id) {
                                this.Ganres[j].Type = "success";
                            }
                        }
                    }
                }                
            },

            //-----------------------------------------------------------------------------
            FilmListCurrentChange(val) {
                this.CurrentFilm = val;
                this.CurrentFilmEdit = JSON.parse(JSON.stringify(this.CurrentFilm));
                this.GanresTypeInit();                
            },

            PageCurrentChange(val) {
                this.CurrentPage = val;
                this.FilmsInit(this.CurrentPage, this.PageSize);
            },

            //-----------------------------------------------------------------------------
            FilmEditCancel() {
                this.EditMode = false;
            },

            FilmEditSave(val) {
                this.EditMode = false;
                this.CurrentFilmEdit = val;                
                this.FilmSave(this.CurrentFilmEdit);                
            }            
        },

        components: {
            FilmListComponent,
            FilmEditComponent
        }
    }
</script>