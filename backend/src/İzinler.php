<?php


namespace Src;


class İzinler
{

    private $db = null;

    public function __construct($db)
    {
        $this->db = $db;
    }

    public function findAll()
    {
        $statement = "
            SELECT 
                *
            FROM
                izinler;
        ";

        try {
            $statement = $this->db->query($statement);
            $result = $statement->fetchAll(\PDO::FETCH_ASSOC);
            return $result;
        } catch (\PDOException $e) {
            exit($e->getMessage());
        }
    }

    public function find($kullanici_id)
    {
        $statement = "
            SELECT 
                *
            FROM
                izinler
            WHERE kullanici_id = :kullanici_id;
        ";

        try {
            $statement = $this->db->prepare($statement);
            $statement->execute(array(
                'kullanici_id' => $kullanici_id
            ));
            $result = $statement->fetchAll(\PDO::FETCH_ASSOC);
            return $result;
        } catch (\PDOException $e) {
            exit($e->getMessage());
        }
    }

    public function insert(array $input)
    {
        $statement = "
            INSERT INTO izinler 
                (kullanici_id, kalan_mazaret_izin, kalan_yillik_izin)
            VALUES
                (:kullanici_id, :kalan_mazaret_izin, :kalan_yillik_izin);
        ";

        try {
            $statement = $this->db->prepare($statement);
            $statement->execute(array(
                'kullanici_id' => $input['kullanici_id'],
                'kalan_mazaret_izin' => $input['kalan_mazaret_izin'],
                'kalan_yillik_izin' => $input['kalan_yillik_izin']
            ));
            return $statement->rowCount();
        } catch (\PDOException $e) {
            exit($e->getMessage());
        }
    }

    public function update($kullanici_id, array $input)
    {
        $statement = "
            UPDATE izinler
            SET 
                kalan_mazaret_izin = :kalan_mazaret_izin,
                kalan_yillik_izin  = :kalan_yillik_izin
            WHERE kullanici_id = :kullanici_id;
        ";

        try {
            $statement = $this->db->prepare($statement);
            $statement->execute(array(
                'kullanici_id' => $kullanici_id,
                'kalan_mazaret_izin' => $input['kalan_mazaret_izin'],
                'kalan_yillik_izin' => $input['kalan_yillik_izin']
            ));
            return $statement->rowCount();
        } catch (\PDOException $e) {
            exit($e->getMessage());
        }
    }
    public function updateYillik($kullanici_id, $kalan_yillik_izin)
    {
        $statement = "
            UPDATE izinler
            SET 
                kalan_yillik_izin  = :kalan_yillik_izin
            WHERE kullanici_id = :kullanici_id;
        ";

        try {
            $statement = $this->db->prepare($statement);
            $statement->execute(array(
                'kullanici_id' => $kullanici_id,
                'kalan_yillik_izin' => $kalan_yillik_izin
            ));
            return $statement->rowCount();
        } catch (\PDOException $e) {
            exit($e->getMessage());
        }
    }

    public function updateMazaret($kullanici_id, $kalan_mazaret_izin)
    {
        $statement = "
            UPDATE izinler
            SET 
                kalan_mazaret_izin = :kalan_mazaret_izin
            WHERE kullanici_id = :kullanici_id;
        ";

        try {
            $statement = $this->db->prepare($statement);
            $statement->execute(array(
                'kullanici_id' => $kullanici_id,
                'kalan_mazaret_izin' => $kalan_mazaret_izin
            ));
            return $statement->rowCount();
        } catch (\PDOException $e) {
            exit($e->getMessage());
        }
    }

    public function delete($kullanici_id)
    {
        $statement = "
            DELETE FROM izinler
            WHERE kullanici_id = :kullanici_id;
        ";

        try {
            $statement = $this->db->prepare($statement);
            $statement->execute(array('kullanici_id' => $kullanici_id));
            return $statement->rowCount();
        } catch (\PDOException $e) {
            exit($e->getMessage());
        }
    }
}