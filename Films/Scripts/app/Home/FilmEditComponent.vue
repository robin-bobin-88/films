<template>
    <div id="FilmEditComponent" v-if="Show && Film != null">
        <el-row :span="24">
            <el-form :model="Film" ref="FilmEditForm" label-width="130px">
                <el-form-item label="Название" prop="FilmName"
                              :rules="[
                                { required: true, message: 'Пожалуйста, укажите название фильма', trigger: 'blur' }
                              ]">
                    <el-col :span="SpanSize">
                        <el-input placeholder="Название" v-model="Film.FilmName"></el-input>
                    </el-col>
                </el-form-item>

                <el-form-item label="Год выпуска" prop="Year"
                              :rules="[
                                { required: true, message: 'Пожалуйста, укажите год выпуска фильма', trigger: 'blur' },
                                { type: 'number', message: 'Пожалуйста, укажите корректный год выпуска фильма', trigger: 'blur'}
                              ]">
                    <el-col :span="SpanSize">
                        <el-input-number v-model="Film.Year"
                                         :min="1900"
                                         :max="2100"
                                         size="medium"
                                         :step="1"
                                         precision="0"
                                         step-strictly>
                        </el-input-number>
                    </el-col>
                </el-form-item>

                <el-form-item label="Страна" prop="CountryId">
                    <el-col :span="SpanSize">
                        <el-select value="Film.CountryId" v-model="Film.CountryId" filterable placeholder="Выберите страну">
                            <el-option v-for="item in Countries"
                                       :key="item.CountryId"
                                       :label="item.CountryName"
                                       :value="item.CountryId">
                            </el-option>
                        </el-select>
                    </el-col>
                </el-form-item>

                <el-form-item label="Режиссер" prop="DirectorId">
                    <el-col :span="SpanSize">
                        <el-select v-model="Film.DirectorId" filterable placeholder="Выберите режиссера">
                            <el-option v-for="item in Directors"
                                       :label="item.DirectorName"
                                       :value="item.DirectorId">
                            </el-option>
                        </el-select>
                    </el-col>
                </el-form-item>

                <el-form-item label="Актеры" prop="ActorList">
                    <el-col :span="SpanSize">
                        <el-select v-model="Film.ActorList" value-key="ActorId" multiple filterable placeholder="Выберите актеров">
                            <el-option v-for="item in Actors"
                                       :key="item.ActorId"
                                       :label="item.ActorName"
                                       :value="item">
                            </el-option>
                        </el-select>
                    </el-col>
                </el-form-item>

                <el-form-item label="Жанры" prop="GanreList">
                    <el-col :span="SpanSize">
                        <el-tag v-for="ganre in Ganres"
                                :key="ganre.GanreId"
                                v-on:click.native="GanreTagClick(ganre)"
                                :type="ganre.Type"
                                style="margin-right: 10px;">
                            {{ganre.GanreName}}
                        </el-tag>
                    </el-col>
                </el-form-item>

                <el-form-item label="Аннотация" prop="Notice"
                              :rules="[
                                { required: true, message: 'Пожалуйста, укажите описание фильма', trigger: 'blur' }
                              ]">
                    <el-col :span="SpanSize">
                        <el-input type="textarea" :rows="4" v-model="Film.Notice"></el-input>
                    </el-col>
                </el-form-item>

            </el-form>
        </el-row>

        <el-row style="margin-top: 20px">
            <el-button v-on:click="FilmSave">
                <i class="el-icon-arrow-down el-icon--left"></i>Сохранить
            </el-button>
            <el-button v-on:click="FilmCancel">
                <i class="el-icon-close el-icon--left"></i>Отмена
            </el-button>
        </el-row>
    </div>
</template>

<script>
    export default {
        name: "FilmEditComponent",

        props: [
            "Film",
            "Countries",
            "Directors",
            "Actors",
            "Ganres",
            "Show"
        ],

        data() {
            return {
                SpanSize: 9                
            }
        },

        methods: {
            FilmCancel() {
                this.$emit("film-edit-cancel");
            },

            FilmSave() {
                this.$refs['FilmEditForm'].validate((valid) => {
                    if (valid) {
                        this.$emit("film-edit-save", this.Film);
                    } else {
                        return false;
                    }
                });
            },

            GanreTagClick(val) {
                val.Type = val.Type == "success" ? "danger" : "success";

                this.Film.GanreList = this.Ganres.filter(function (item) {
                    return item.Type == "success";
                });

                this.Film.GanreList.sort(function (a, b) {
                    if (a.GanreName > b.GanreName)
                        return 1;
                    if (a.GanreName < b.GanreName)
                        return -1;
                    return 0;
                });
            }
        }
    }
</script>